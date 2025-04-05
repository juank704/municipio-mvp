{
    'name': 'Custom User Menu',
    'version': '1.0',
    'category': 'Hidden',
    'summary': 'Hide unnecessary items from user menu',
    'depends': ['web'],
    'data': [
        'views/user_menu_override.xml',
    ],
    'assets': {
        'web.assets_backend': [
            'custom_user_menu/static/src/xml/user_menu_override.xml',
        ],
    },
    'installable': True,
    'auto_install': True,
}
