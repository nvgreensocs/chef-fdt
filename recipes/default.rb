
#  -------    CHEF-DTC --------

# LICENSETEXT
# 
#   Copyright (C) 2013 : GreenSocs Ltd
#       http://www.greensocs.com/ , email: info@greensocs.com
# 
# The contents of this file are subject to the licensing terms specified
# in the file LICENSE. Please consult this file for restrictions and
# limitations that may apply.
# 
# ENDLICENSETEXT

directory "#{node[:prefix]}/dtc-temp" do
  action :create
  recursive true
end


bash "Checkout DTC" do
  code <<-EOH
# need to specify branch
  git clone git://jdl.com/software/dtc.git #{node[:prefix]}/dtc-temp/dtc
  EOH
  creates "#{node[:prefix]}/dtc-temp/dtc"
  environment ({ 'http_proxy' => Chef::Config[:http_proxy] })
end

bash "Update DTC" do
  code <<-EOH
    cd #{node[:prefix]}/dtc-temp/dtc
    git reset --hard v1.3.0
  EOH
  environment ({ 'http_proxy' => Chef::Config[:http_proxy] })
end

ruby_block "compile DTC" do
  block do
     IO.popen(  <<-EOH
     cd #{node[:prefix]}/dtc-temp/dtc
     make
     make install PREFIX=/usr       
     EOH
   ) { |f|  f.each_line { |line| puts line } }
  end
end
