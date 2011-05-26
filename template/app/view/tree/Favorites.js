/**
 * Favorites button with fly-out menu of entries.
 */
Ext.define('Docs.view.tree.Favorites', {
	extend: 'Ext.Component',
	alias: 'widget.docsfavoritesbutton',

	id: 'favoritesBtn',
	html: '<span></span>Favorites',

	afterRender: function() {
        this.callParent(arguments);

        this.getEl().on({
            mouseover: function() {
                if (!this.hoverMenu) {
                    this.renderMenu();
                }

                this.hoverMenu.show();
                clearTimeout(this.hideTimeout);
    	    },
            mouseout: this.deferHideMenu,
            scope: this
        });

	},

    renderMenu: function() {
        this.hoverMenu = Ext.create('Docs.view.tree.HoverMenu', {
            emptyText: 'No favorites',
            store: Docs.App.getStore('Favorites')
        });

        this.hoverMenu.getEl().setVisibilityMode(Ext.core.Element.DISPLAY);

        this.hoverMenu.getEl().on({
            mouseover: function() {
                clearTimeout(this.hideTimeout);
            },
            mouseout: this.deferHideMenu,
            click: function(e) {
                if (e.getTarget(".close")) {
                    var cls = e.getTarget().rel;
                    Docs.Favorites.remove(e.getTarget().rel);
                } else {
                    this.hoverMenu.hide();
                }
                e.preventDefault();
            },
            scope: this
        });

        var p = this.getEl().getXY();
        this.hoverMenu.getEl().setStyle({
            left: "20px",
            width: "220px",
            top: (p[1]+23)+"px"
        });
    },

    deferHideMenu: function() {
        this.hideTimeout = Ext.Function.defer(function() {
            this.hoverMenu.hide();
        }, 200, this);
    }
});
