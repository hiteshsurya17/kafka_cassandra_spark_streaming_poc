sudo systemctl status cassandra # check the status of cassandra if not active start it using:
sudo systemctl start cassandra 
# open cassandra shell (repl)
cqlsh # to open repl
# create a Keyspace , In cassandra databases are called as keyspaces
create keyspace sparkdata with replication = {'class':'SimpleStrategy','replication_factor':1};
use sparkdata;
# create a table 
create table cust_data (fname text , lname text , url text,product text,cnt counter, primary key (fname ,lname,url,product));

