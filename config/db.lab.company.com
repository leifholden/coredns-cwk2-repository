$ORIGIN lab.company.com.
@    IN    SOA    dns.lab.company.com    manager.company.com    2603151630    3600    60    3600    3600

dns  IN    A      172.17.0.1
ins1 IN    A      172.17.0.2
ins2 IN    A      172.17.0.3
ins3 IN    A      172.17.0.4
