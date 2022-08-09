# theme sources .scss files
accent_colors = get_option('accent-colors')

variants = []

foreach accent : accent_colors
  variants += (accent)
  variants += (accent + '-dark')
endforeach

# The files that need to be compiled
gtk3_scss = 'gtk'
gtk3_scss_dark = 'gtk-dark'

scss_dir = join_paths(meson.project_name(), 'gtk-3.0')
accent_colors_scss = scss_dir / 'accent-colors.scss.in'

foreach variant : variants
  theme_name = meson.project_name() + '-' + variant
  theme_dir = join_paths(get_option('prefix'), get_option('datadir'), 'themes', theme_name)
  gtk3_dir = join_paths(theme_dir, 'gtk-3.0')

  conf_data = configuration_data()
  conf_data.set('ThemeName', meson.project_name())
  conf_data.set('VariantThemeName', meson.project_name() + '-' + variant)
  index = configure_file(input : 'index.theme.in',
                         output : '@0@-index.theme'.format(theme_name),
                         configuration : conf_data,
                         install: false)
  install_data(index,
    install_dir: theme_dir,
    rename: 'index.theme')

  # Generate .css files and install
  gtk3_scss_dependencies = []
  scss_dependencies = run_command(
    'find', scss_dir, '-name', '*.scss'
  ).stdout().strip().split('\n')
  gtk3_scss_dependencies += scss_dependencies

  if variant.endswith('-dark')
    is_dark = true
  else
    is_dark = false
  endif

  if is_dark
    color = variant.split('-dark')[0]
    gtk3_scss_sources = [
      gtk3_scss,
      gtk3_scss_dark,
    ]
  else
    color = variant
    gtk3_scss_sources = [
      gtk3_scss_dark,
    ]
  endif
  foreach f : gtk3_scss_sources
    conf_data = configuration_data()
    conf_data.set('color', color)
    conf_data.set('dg-adw-gtk', meson.current_source_dir() / scss_dir / f)
    gtk_accents_scss = configure_file(input : accent_colors_scss,
                                      output : '@0@-@1@-accent-colors.scss'.format(theme_name, f),
                                      configuration : conf_data)

    custom_target('generate-@0@-@1@'.format(theme_name, f),
      input: gtk_accents_scss,
      output: '@0@-@1@-generated.css'.format(theme_name, f),
      depend_files: files(gtk3_scss_dependencies),
      command: [sassc, '-M', '-t', 'compact', '@INPUT@', '@OUTPUT@'],
      build_by_default: true)

    if is_dark
      meson.add_install_script('install-css.sh', meson.current_build_dir() / '@0@-@1@-generated.css'.format(theme_name, f), gtk3_dir / f + '.css', gtk3_dir, gtk3_dir / 'gtk.css')
    else
      meson.add_install_script('install-css.sh', meson.current_build_dir() / '@0@-@1@-generated.css'.format(theme_name, f), gtk3_dir / f + '.css', gtk3_dir)
    endif
  endforeach

# Install asset files to themes/ThemeName/gtk-3.0/assets
install_subdir(scss_dir / 'assets', install_dir : gtk3_dir, strip_directory : false)
endforeach
