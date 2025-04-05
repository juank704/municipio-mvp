{
    'name': 'Custom User Menu',
    'version': '1.0',
    'category': 'Hidden',
    'summary': 'Hide unnecessary items from user menu',
    'depends': ['web'],
    'data': [],
    'assets': {
        'web.assets_backend': [
            '/custom_user_menu/static/src/js/debug.js',
        ],
    },
    'installable': True,
    'auto_install': True,
}
