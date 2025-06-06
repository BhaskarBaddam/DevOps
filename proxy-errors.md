To check existing proxy url settings, use
```
echo $http_proxy
echo $https_proxy
echo $no_proxy
```

Search for any of these files for above settings - /etc/environment, ~/.bashrc, ~/.bash_profile.\
Remove those proxy urls and run below commands respectively to reload files.
```
source /etc/environment
source ~/.bashrc
source ~/.bash_profile
```

While running podman build/push with non-root user, we may get below error
> ```["time=\"2025-06-06T11:53:47+01:00\" level=error msg=\"reading system config \\\"/etc/containers/containers.conf\\\": decode configuration /etc/containers/containers.conf: open /etc/containers/containers.conf: permission denied\""]```

then we need to change permission for /etc/containers/containers.conf as below
```
sudo chmod 644 /etc/containers/containers.conf
```

