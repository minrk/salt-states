newrelic-ppa:
  pkgrepo.managed:
    - human_name: New Relic PPA
    - name: deb http://apt.newrelic.com/debian/ newrelic non-free
    - key_url: http://download.newrelic.com/548C16BF.gpg

newrelic-php5:
  pkg.installed:
    - require:
      - pkgrepo: newrelic-ppa

newrelic-sysmond:
  pkg.installed:
    - require:
      - pkgrepo: newrelic-ppa
  service.running:
    - watch:
      - pkg: newrelic-sysmond
      - cmd: newrelic-sysmond-conf

newrelic-sysmond-conf:
  cmd.run:
    - name: nrsysmond-config --set license_key={{ pillar['newrelic']['license_key'] }}
    - require:
      - pkg: newrelic-sysmond

/etc/php5/fpm/conf.d/newrelic.ini:
  file.managed:
    - source: salt://newrelic/newrelic.ini
    - template: jinja
    - require:
      - pkg: newrelic-php5
      - pkgrepo: newrelic-ppa