# theme sources .scss files
accent_colors = get_option('accent-colors')

variants = ['default', 'default-dark']

foreach accent : accent_colors
  variants += (accent)
  variants += (accent + '-dark')
endforeach

# The files that need to be compiled
gtk_scss = 'gtk'
gtk_scss_dark = 'gtk-dark'

scss_dir = join_paths(meson.project_name(), 'gtk-3.0')
gtk4_scss_dir = join_paths(meson.project_name(), 'gtk-4.0')
accent_colors_scss = scss_dir / 'accent-colors.scss.in'

foreach variant : variants
  ########################
  #  Install GTK3 theme  #
  ########################

  if variant == 'default'
    theme_name = meson.project_name()
  elif variant == 'default-dark'
    theme_name = meson.project_name() + '-dark'
  else
    theme_name = meson.project_name() + '-' + variant
  endif

  icon_theme = theme_name
  if not icon_theme.endswith('-dark')
    icon_theme += '-dark'
  endif

  if variant.endswith('-dark')
    metacity = meson.project_name() + '-dark'
  else
    metacity = meson.project_name()
  endif

  themes_dir = join_paths(get_option('prefix'), get_option('datadir'), 'themes')
  theme_dir = join_paths(themes_dir, theme_name)
  gtk3_dir = join_paths(theme_dir, 'gtk-3.0')
  gtk4_dir = join_paths(theme_dir, 'gtk-4.0')

  conf_data = configuration_data()
  conf_data.set('FullThemeName', theme_name)
  conf_data.set('VariantThemeName', theme_name)
  conf_data.set('MetacityThemeName', metacity)
  conf_data.set('IconThemeName', icon_theme)
  conf_data.set('CursorThemeName', meson.project_name())
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

  gtk3_scss_sources = []

  if is_dark
    color = variant.split('-dark')[0]
    if get_option('gtk3')
      gtk3_scss_sources = [
        gtk_scss_dark,
      ]
    endif
  else
    color = variant
    if get_option('gtk3')
      gtk3_scss_sources = [
        gtk_scss,
        gtk_scss_dark,
      ]
    endif
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

  ########################
  #  Install GTK4 theme  #
  ########################

  if variant == 'default' or variant == 'default-dark'
    gtk4_scss_dependencies = []
    scss_dependencies = run_command(
      'find', gtk4_scss_dir, '-name', '*.scss'
    ).stdout().strip().split('\n')
    gtk4_scss_dependencies += scss_dependencies

    gtk4_scss_sources = []

    if is_dark
      color = variant.split('-dark')[0]
      if get_option('gtk4')
        gtk4_scss_sources = [
          gtk_scss_dark,
        ]
      endif
    else
      color = variant
      if get_option('gtk4')
        gtk4_scss_sources = [
          gtk_scss,
          gtk_scss_dark,
        ]
      endif
    endif

    foreach f : gtk4_scss_sources
      custom_target('generate-@0@-@1@-gtk4'.format(theme_name, f),
        input: gtk4_scss_dir / f + '.scss',
        output: '@0@-@1@-generated-gtk4.css'.format(theme_name, f),
        depend_files: files(gtk4_scss_dependencies),
        command: [sassc, '-M', '-t', 'compact', '@INPUT@', '@OUTPUT@'],
        build_by_default: true)

      if is_dark
        meson.add_install_script('install-css.sh', meson.current_build_dir() / '@0@-@1@-generated-gtk4.css'.format(theme_name, f), gtk4_dir / f + '.css', gtk4_dir, gtk4_dir / 'gtk.css')
      else
        meson.add_install_script('install-css.sh', meson.current_build_dir() / '@0@-@1@-generated-gtk4.css'.format(theme_name, f), gtk4_dir / f + '.css', gtk4_dir)
      endif
    endforeach
  endif

  ####################
  #  Install Assets  #
  ####################

  if variant == 'default'
    # Install asset files to themes/ThemeName/gtk-3.0/assets
    install_subdir(scss_dir / 'assets', install_dir : gtk3_dir, strip_directory : false)

    # Install asset files to themes/ThemeName/gtk-4.0/assets
    install_subdir(gtk4_scss_dir / 'assets', install_dir : gtk4_dir, strip_directory : false)
  endif

  ##############
  #  Symlinks  #
  ##############

  if variant != 'default'
    meson.add_install_script('bash', '-c', 'ln -rsf @0@ @1@'.format(themes_dir / meson.project_name() / 'gtk-3.0' / 'assets', gtk3_dir))
  endif
  if variant == 'default-dark'
    meson.add_install_script('bash', '-c', 'ln -rsf @0@ @1@'.format(themes_dir / meson.project_name() / 'gtk-4.0' / 'assets', gtk4_dir))
  endif

  if not variant.startswith('default') and not variant.endswith('-dark')
    meson.add_install_script('bash', '-c', 'ln -rsf @0@ @1@'.format(themes_dir / meson.project_name() / 'gtk-4.0', theme_dir))
  elif not variant.startswith('default')
    meson.add_install_script('bash', '-c', 'ln -rsf @0@ @1@'.format(themes_dir / meson.project_name() + '-dark' / 'gtk-4.0', theme_dir))
  endif

  ################
  #  Thumbnails  #
  ################

  install_data(
    'thumbnails' / 'thumbnail-@0@.png'.format(variant),
    install_dir: theme_dir,
    rename: 'thumbnail.png'
  )
endforeach
