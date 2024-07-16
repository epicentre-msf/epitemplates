
# quietly delete a temporary location
#
quietly_delete = function(dir){
  xfun::try_silent({
    fs::dir_delete(dir)
  })
}

# create a temporary location
tmp_loc = function(dir){
  tmp = fs::path_temp(dir)
  quietly_delete(tmp)
  tmp
}

