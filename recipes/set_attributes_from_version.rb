# Cookbook:: java
# Recipe:: set_attributes_from_version
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Calculate variables that depend on jdk_version
# If you need to override this in an attribute file you must use
# force_default or higher precedence.

case node['platform_family']
when 'rhel', 'fedora', 'amazon'
  node.default['java']['java_home'] = case node['java']['install_flavor']
                                      when 'oracle'
                                        '/usr/lib/jvm/java'
                                      when 'oracle_rpm'
                                        '/usr/java/latest'
                                      else
                                        node['java']['jdk_version'].to_i < 11 ? "/usr/lib/jvm/java-1.#{node['java']['jdk_version']}.0" : "/usr/lib/jvm/java-#{node['java']['jdk_version']}"
                                      end
  node.default['java']['openjdk_packages'] = node['java']['jdk_version'].to_i < 11 ? ["java-1.#{node['java']['jdk_version']}.0-openjdk", "java-1.#{node['java']['jdk_version']}.0-openjdk-devel"] : ["java-#{node['java']['jdk_version']}-openjdk", "java-#{node['java']['jdk_version']}-openjdk-devel"]
when 'suse'
  node.default['java']['java_home'] = case node['java']['install_flavor']
                                      when 'oracle'
                                        '/usr/lib/jvm/java'
                                      when 'oracle_rpm'
                                        '/usr/java/latest'
                                      else
                                        "/usr/lib#{node['kernel']['machine'] == 'x86_64' ? '64' : nil}/jvm/java-1.#{node['java']['jdk_version']}.0"
                                      end
  node.default['java']['openjdk_packages'] = ["java-1_#{node['java']['jdk_version']}_0-openjdk", "java-1_#{node['java']['jdk_version']}_0-openjdk-devel"]
when 'freebsd'
  node.default['java']['java_home'] = "/usr/local/openjdk#{node['java']['jdk_version']}"
  jdk_version = node['java']['jdk_version']
  openjdk_package = jdk_version == '7' ? 'openjdk' : "openjdk#{node['java']['jdk_version']}"
  node.default['java']['openjdk_packages'] = [openjdk_package]
when 'arch'
  node.default['java']['java_home'] = "/usr/lib/jvm/java-#{node['java']['jdk_version']}-openjdk"
  node.default['java']['openjdk_packages'] = ["openjdk#{node['java']['jdk_version']}"]
when 'debian'
  node.default['java']['java_home'] = "/usr/lib/jvm/java-#{node['java']['jdk_version']}-#{node['java']['install_flavor']}-#{node['kernel']['machine'] == 'x86_64' ? 'amd64' : 'i386'}"
  node.default['java']['openjdk_packages'] = ["openjdk-#{node['java']['jdk_version']}-jdk", "openjdk-#{node['java']['jdk_version']}-jre-headless"]
when 'smartos'
  node.default['java']['java_home'] = '/opt/local/java/sun6'
  node.default['java']['openjdk_packages'] = ["sun-jdk#{node['java']['jdk_version']}", "sun-jre#{node['java']['jdk_version']}"]
when 'windows'
  node.default['java']['java_home'] = nil
when 'mac_os_x'
  java_home = if node['java']['jdk_version'].to_i >= 10
                "$(/usr/libexec/java_home -v #{node['java']['jdk_version']})"
              else
                "$(/usr/libexec/java_home -v 1.#{node['java']['jdk_version']})"
              end
  node.default['java']['java_home'] = java_home
else
  node.default['java']['java_home'] = '/usr/lib/jvm/default-java'
  node.default['java']['openjdk_packages'] = ["openjdk-#{node['java']['jdk_version']}-jdk"]
end

unless node['java']['override_java_home'].empty?
  node.default['java']['java_home'] = node['java']['override_java_home']
end