FROM centos:latest
RUN yum install -y -q epel-release
RUN (yum install -y -q xorg-x11-server-Xvfb python2-pip ruby ruby-devel rubygem-rspec wget bzip2 gcc make pulseaudio >> dev/null)
RUN (yum install -y -q firefox-45.4.0-1.el7.centos >> /dev/null)
RUN wget -q https://ftp.mozilla.org/pub/firefox/releases/45.3.0esr/linux-x86_64/en-US/firefox-45.3.0esr.tar.bz2 -O /root/firefox.tar.bz2
RUN (cd /root/;tar -jxf firefox.tar.bz2)
RUN (pip install selenium >> /dev/null)
RUN (gem install selenium-webdriver -v 2.53.4 >> /dev/null)
RUN (gem install rspec-retry -v 0.4.6 >> /dev/null)
RUN (gem install rspec_junit_formatter rspec-wait >> /dev/null)
RUN mkdir -p /root/selenium_wd_tests
RUN mkdir -p /root/.mozilla/firefox
ADD stam_types.lst /root/selenium_wd_tests
ADD firefox-default /root/.mozilla/firefox/firefox-default
ADD skip_cert_error-0.4.4-fx.xpi /root/.mozilla/firefox
ADD profiles.ini /root/.mozilla/firefox
ADD xvfb.init /etc/init.d/xvfb
ADD post_stam_smoketest_ruby_webdriver /root/selenium_wd_tests
RUN chmod +x /etc/init.d/xvfb 
RUN chkconfig xvfb on
RUN mkdir -p /results
RUN (dbus-uuidgen > /etc/machine-id)
CMD (/etc/init.d/xvfb start;export DISPLAY=":10" PATH="$PATH:/root/firefox";cd /root/selenium_wd_tests/;target_host=${target_host} target_user=${target_user} target_pass=${target_pass} rspec post_stam_smoketest_ruby_webdriver --format RspecJunitFormatter --out /results/results.xml)
