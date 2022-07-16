gtk3_dir = join_paths(theme_dir, 'gtk-3.0')

# Install asset files to themes/ThemeName/gtk-3.0/assets
install_subdir('assets', install_dir : gtk3_dir, strip_directory : false)

# theme sources .scss files

# The files that need to be compiled
gtk3_scss = 'gtk' 
gtk3_scss_dark = 'gtk-dark'

if get_option('dark')
  gtk3_scss_sources = [
    gtk3_scss,
    gtk3_scss_dark,
  ]
else
  gtk3_scss_sources = [
    gtk3_scss,
    gtk3_scss_dark,
  ]
endif

# Dependencies of the files that need to be compiled
gtk3_scss_dependencies = [
  'gtk.scss',
  'gtk-dark.scss',
  '_functions.scss',
  '_palette.scss',
  '_defaults.scss',
  '_colors-public.scss',
  '_custom.scss',
  '_colors.scss',
  '_common.scss',
  '_drawing.scss',
  '_libhandy.scss',
  '_granite.scss',
  '_apps.scss',
  '_phosh.scss',
]

# Generate .css files and install
gtk3_scss_dependencies = files(gtk3_scss_dependencies)
#
accent = get_option('accent')
foreach f : gtk3_scss_sources
  conf_data = configuration_data()
  conf_data.set('color', accent)
  conf_data.set('dg-adw-gtk', meson.current_source_dir() / f)
  gtk_accents_css = configure_file(input : 'accent-colors.scss.in',
                                   output : '@0@-accent-colors.scss'.format(f),
                                   configuration : conf_data)
  custom_target('generate_' + f,
    input: gtk_accents_css,
    output: f + '.css',
    depend_files: gtk3_scss_dependencies,
    command: [sassc, '-M', '-t', 'compact', '@INPUT@', '@OUTPUT@'],
    build_by_default: true,
    install: true,
    install_dir: gtk3_dir,
  )
endforeach
