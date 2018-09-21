# vim: ts=2 sw=2 et
#
# Copyright (c) 2016-2018 Jorrit Folmer
#

class splunk::outputs (
  $type = $splunk::type,
  $tcpout = $splunk::tcpout,
  $clustering = $splunk::clustering,
  $splunk_os_user = $splunk::real_splunk_os_user,
  $splunk_os_group = $splunk::real_splunk_os_group,
  $splunk_dir_mode = $splunk::real_splunk_dir_mode,
  $splunk_file_mode = $splunk::real_splunk_file_mode,
  $splunk_home    = $splunk::splunk_home,
  $splunk_app_precedence_dir = $splunk::splunk_app_precedence_dir,
  $splunk_app_replace = $splunk::splunk_app_replace,
  $use_ack = $splunk::use_ack,
  $sslrootcapath = $splunk::sslrootcapath,
  $sslcertpath = $splunk::sslcertpath,
  $sslpassword = $splunk::sslpassword,
  $sslverifyservercert = $splunk::sslverifyservercert
){
  # if $clustering[cm] == undef and $type == undef {
  #  $cm = "${::fqdn}:8089"
  #} elsif $clustering[cm] == undef and $type == 'uf' and $tcpout == 'indexer_discovery' {
  #  fail 'please set cluster master when using indexer_discovery'
  #} else {
  #  $cm = $clustering[cm]
  #}
  #  if $clustering[pass4symmkey] == undef {
  #  $pass4symmkey = $splunk::pass4symmkey
  #} else {
  #  $pass4symmkey = $clustering[pass4symmkey]
  #}
  $splunk_app_name = 'puppet_common_ssl_outputs'
  if $tcpout == undef {
    file {"${splunk_home}/etc/apps/${splunk_app_name}":
      ensure  => absent,
      recurse => true,
      purge   => true,
      force   => true,
    }
  } else {
    file { ["${splunk_home}/etc/apps/${splunk_app_name}",
            "${splunk_home}/etc/apps/${splunk_app_name}/${splunk_app_precedence_dir}",
            "${splunk_home}/etc/apps/${splunk_app_name}/metadata",]:
      ensure => directory,
      owner  => $splunk_os_user,
      group  => $splunk_os_group,
      mode   => $splunk_dir_mode,
    }
    -> file { "${splunk_home}/etc/apps/${splunk_app_name}/${splunk_app_precedence_dir}/outputs.conf":
      ensure  => present,
      owner   => $splunk_os_user,
      group   => $splunk_os_group,
      mode    => $splunk_file_mode,
      replace => $splunk_app_replace,
      content => template("splunk/${splunk_app_name}/local/outputs.conf"),
    }
  }
}

