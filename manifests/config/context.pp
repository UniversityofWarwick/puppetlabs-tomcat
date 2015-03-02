
# Defines a context.xml under conf/.
# The content of the file is partly determined
# by other defines such as `tomcat::config::context::resource`.
define tomcat::config::context(
  $catalina_base = $::tomcat::catalina_home,
  ) {

  $filename = "${catalina_base}/conf/context.xml"

  concat::fragment { "${catalina_base}-context-header" :
    target  => $filename,
    content => '<?xml version="1.0" encoding="UTF-8"?>\n<Context>',
    order   => 0,
  }

  concat::fragment { "${catalina_base}-context-footer" :
    target  => $filename,
    content => '</Context>',
    order   => 1000,
  }

  concat { $filename : 
    ensure => present,
    backup => false,
  }

}