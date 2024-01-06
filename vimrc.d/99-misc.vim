if system('id -u') != 0 && executable('sudo') && executable('tee')
  cmap w!! write !sudo tee >/dev/null '%:p'
endif
