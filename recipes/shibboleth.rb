include_recipe "shibboleth"

web_app "round-three-shib" do
  template "round-three-shib.conf.erb"
  exempted_paths node['round-three']['redirects'].keys.map{|k| "(?!#{k}/)"}.join
end

cookbook_file '/etc/shibboleth/attributes.d/umass.xml' do
  mode '0644'
  notifies :create, 'ruby_block[build-attribute-map]'
end
