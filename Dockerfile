FROM ubuntu:xenial
RUN apt-get update -qq
RUN apt-get install -qq -y firefox xvfb python-pip ruby ruby-dev wget firefox
RUN apt-get remove -qq -y firefox 
RUN wget -q https://ftp.mozilla.org/pub/firefox/releases/45.3.0esr/linux-x86_64/en-US/firefox-45.3.0esr.tar.bz2 -O /root/firefox.tar.bz2
RUN (cd /root/;tar -jxf firefox.tar.bz2)
RUN pip install selenium
RUN gem install selenium-webdriver -v 2.53.4 # Pinned due to major changes in v3
RUN mkdir -p /root/selenium_wd_tests
RUN mkdir -p /root/.mozilla/firefox
ADD stam_types.lst /root/selenium_wd_tests
ADD firefox-default /root/.mozilla/firefox/firefox-default
ADD skip_cert_error-0.4.4-fx.xpi /root/.mozilla/firefox
ADD profiles.ini /root/.mozilla/firefox
ADD xvfb.init /etc/init.d/xvfb
ADD geckodriver /root/firefox/
ADD post_stam_smoketest_ruby_webdriver /root/selenium_wd_tests
RUN chmod +x /etc/init.d/xvfb 
RUN update-rc.d xvfb defaults
CMD (service xvfb start; export DISPLAY=:10;export PATH="$PATH:/root/firefox/";cd /root/selenium_wd_tests/;target_host="$target_host" target_user="$target_user" target_pass="$target_pass" ruby post_stam_smoketest_ruby_webdriver)
