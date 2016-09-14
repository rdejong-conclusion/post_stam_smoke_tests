FROM ubuntu:xenial
RUN apt-get update 
RUN apt-get install -q -y firefox xvfb python-pip ruby ruby-dev wget firefox
RUN apt-get remove -q -y firefox 
RUN wget -q https://ftp.mozilla.org/pub/firefox/releases/45.3.0esr/linux-x86_64/en-US/firefox-45.3.0esr.tar.bz2 -O /root/firefox.tar.bz2
RUN (cd /root/;tar -jxf firefox.tar.bz2)
RUN pip install selenium
RUN gem install selenium-webdriver 
RUN mkdir -p /root/selenium_wd_tests
RUN mkdir -p /root/.mozilla/firefox
ADD post_plan_smoketest_o8_ruby_webdriver /root/selenium_wd_tests
ADD firefox-default /root/.mozilla/firefox/firefox-default
ADD skip_cert_error-0.4.4-fx.xpi /root/.mozilla/firefox
ADD profiles.ini /root/.mozilla/firefox
ADD xvfb.init /etc/init.d/xvfb
RUN chmod +x /etc/init.d/xvfb 
RUN update-rc.d xvfb defaults
RUN echo 'nameserver 10.4.6.3' >> /etc/resolv.conf
RUN echo '10.100.0.106  o8wlsnode1.infoplus-ot.ris' >> /etc/hosts
CMD (service xvfb start; export DISPLAY=:10; ruby /root/selenium_wd_tests/post_plan_smoketest_o8_ruby_webdriver)
