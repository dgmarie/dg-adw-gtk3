# theme sources .scss files
accent_colors = get_option('accent-colors')
window_controls = get_option('window-controls')

variants = []
if 'macos' in window_controls
  variants += ['default-macos', 'default-dark-macos']
endif
if 'symbolic' in window_controls
  variants += ['default-symbolic', 'default-dark-symbolic']
endif

foreach accent : accent_colors
  foreach variant : window_controls
    variants += (accent + '-' + variant)
    variants += (accent + '-dark' + '-' + variant)
  endforeach
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

  gtk3_scss_sources = []

  is_dark = variant.contains('-dark') ? true : false

  is_symbolic = variant.endswith('-symbolic') ? true : false

  window_controls_variant = is_symbolic ? 'symbolic' : 'macos'

  if is_dark
    suffix = '-dark-' + window_controls_variant
    color = variant.split('-dark')[0]
    thumbnail = color + '-dark'
    if get_option('gtk3')
      gtk3_scss_sources += [
        gtk_scss_dark + '-' + window_controls_variant,
      ]
    endif
  else
    suffix = '-' + window_controls_variant
    color = variant.split('-')[0]
    thumbnail = color
    if get_option('gtk3')
      gtk3_scss_sources += [
        gtk_scss + '-' + window_controls_variant,
        gtk_scss_dark + '-' + window_controls_variant
      ]
    endif
  endif

  if variant.contains('default')
    icon_theme = meson.project_name() + '-dark'
  else
    icon_theme = meson.project_name() + color + '-dark'
  endif

  if variant.contains('default')
    theme_name = meson.project_name() + suffix
  else
    theme_name = meson.project_name() + '-' + variant
  endif

  metacity = meson.project_name() + suffix

  themes_dir = join_paths(get_option('prefix'), get_option('datadir'), 'themes')
  theme_dir = join_paths(themes_dir, theme_name)
  gtk2_dir = join_paths(theme_dir, 'gtk-2.0')
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

    dest = f.contains('-dark') ? 'gtk-dark.css' : 'gtk.css'

    if is_dark
      meson.add_install_script('install-css.sh', meson.current_build_dir() / '@0@-@1@-generated.css'.format(theme_name, f), gtk3_dir / dest, gtk3_dir, gtk3_dir / 'gtk.css')
    else
      meson.add_install_script('install-css.sh', meson.current_build_dir() / '@0@-@1@-generated.css'.format(theme_name, f), gtk3_dir / dest, gtk3_dir)
    endif
  endforeach

  ########################
  #  Install GTK4 theme  #
  ########################

  if variant.startswith('default')
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
        meson.add_install_script('install-css.sh', meson.current_build_dir() / '@0@-@1@-generated-gtk4.css'.format(theme_name, f), gtk4_dir / 'gtk-dark.css', gtk4_dir, gtk4_dir / 'gtk.css')
      else
        meson.add_install_script('install-css.sh', meson.current_build_dir() / '@0@-@1@-generated-gtk4.css'.format(theme_name, f), gtk4_dir / 'gtk.css', gtk4_dir)
      endif
    endforeach
  endif

  ####################
  #  Install Assets  #
  ####################

  if variant in ['default-macos', 'default-symbolic']
    if get_option('gtk3')
      # Install asset files to themes/ThemeName/gtk-3.0/assets
      install_subdir(scss_dir / 'assets', install_dir : gtk3_dir, strip_directory : false)
    endif
    if get_option('gtk4')
      # Install asset files to themes/ThemeName/gtk-4.0/assets
      install_subdir(gtk4_scss_dir / 'assets', install_dir : gtk4_dir, strip_directory : false)
    endif
  endif

  ##############
  #  Symlinks  #
  ##############

  if variant not in ['default-macos', 'default-symbolic'] and get_option('gtk3')
    meson.add_install_script('symlink.sh', themes_dir / meson.project_name() + '-' + window_controls_variant / 'gtk-3.0', gtk3_dir, 'assets')
  endif
  if variant.contains('default-dark') and get_option('gtk4')
    meson.add_install_script('symlink.sh', themes_dir / meson.project_name() + '-' + window_controls_variant / 'gtk-4.0', gtk4_dir, 'assets')
  endif

  if not variant.startswith('default') and get_option('gtk4')
    meson.add_install_script('symlink.sh', themes_dir / meson.project_name() + suffix, theme_dir,  'gtk-4.0')
  endif

  ################
  #  Thumbnails  #
  ################

  if get_option('gtk3')
    install_data(
      meson.current_source_dir() / 'thumbnails' / 'thumbnail-@0@.png'.format(thumbnail),
      install_dir: gtk3_dir,
      rename: 'thumbnail.png'
    )

    # Create an empty gtk2 dir to allow theme to be seen in cinnamon settings
    meson.add_install_script('mkdir', '-p', '${DESTDIR}' / gtk2_dir)
  endif
endforeach
