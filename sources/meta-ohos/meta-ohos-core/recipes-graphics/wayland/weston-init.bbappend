# SPDX-FileCopyrightText: Huawei Inc.
#
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:${OHOS_COREBASE}/assets:"

SRC_URI += "${@oe.utils.conditional('WESTON_INI_BACKGROUND_IMAGE', '', '', "file://${WESTON_INI_BACKGROUND_IMAGE_BASENAME}", d)}"

WESTON_DYNAMIC_INI ?= "0"
WESTON_INI_PATH ?= "etc/xdg/weston/weston.ini"

WESTON_INI_NO_TOOLBAR ?= "0"
WESTON_INI_BACKGROUND_IMAGE ?= ""
WESTON_INI_BACKGROUND_IMAGE_BASENAME = "${@os.path.basename("${WESTON_INI_BACKGROUND_IMAGE}")}"
WESTON_INI_BACKGROUND_COLOR ?= "0xffffffff"
WESTON_INI_BACKGROUND_TYPE ?= "centered"

do_install_append() {
	# The filename references in WESTON_INI_BACKGROUND_IMAGE needs to be
	# provided in SRC_URI/WORKDIR.
	if [ -n "${WESTON_INI_BACKGROUND_IMAGE}" ]; then
		mkdir -p "${D}/$(dirname ${WESTON_INI_BACKGROUND_IMAGE})"
		install -m 0644 "${WORKDIR}/$(basename ${WESTON_INI_BACKGROUND_IMAGE})" \
			"${D}/$(dirname ${WESTON_INI_BACKGROUND_IMAGE})"
	fi
}

python generate_dynamic_ini() {
    import configparser

    # Avoid everything if dynamic configuration is not requested .
    do = d.getVar('WESTON_DYNAMIC_INI', True)
    if do != '1':
        bb.note("No dynamic weston.ini configuration requested.")
        return
    bb.note("Dynamic weston.ini configuration requested.")

    config = configparser.ConfigParser()
    ini_path = os.path.join(d.getVar('D', True), d.getVar('WESTON_INI_PATH', True))

    # Prepopulate an existing configuration.
    if os.path.exists(ini_path):
        if not os.path.isfile(ini_path):
            bb.fatal("weston.ini already exists and it is not a regular file")
        config.read(ini_path)

    # Handle no toolbar configuration.
    if d.getVar('WESTON_INI_NO_TOOLBAR', True) == '1':
        bb.note('Handling WESTON_INI_NO_TOOLBAR.')
        if 'shell' not in config.sections():
            config.add_section('shell')
        config.set('shell', 'panel-position', 'none')

    # Handle background.
    background_image = d.getVar('WESTON_INI_BACKGROUND_IMAGE', True)
    if background_image:
        bb.note('Handling WESTON_INI_BACKGROUND_IMAGE.')
        background_color = d.getVar('WESTON_INI_BACKGROUND_COLOR', True)
        background_type = d.getVar('WESTON_INI_BACKGROUND_TYPE', True)
        if 'shell' not in config.sections():
            config.add_section('shell')
        config.set('shell', 'background-image', background_image)
        config.set('shell', 'background-color', background_color)
        config.set('shell', 'background-type', background_type)

    # Finally, write the configuration. Keep this at the end.
    with open(ini_path, 'w') as init_path_fo:
        config.write(init_path_fo, space_around_delimiters=False)
}
do_install[postfuncs] += "generate_dynamic_ini"

FILES_${PN} += "${WESTON_INI_BACKGROUND_IMAGE}"
