

ldifde -f  c:\tmp\exportou.ldf -s tjadp01 -d "dc=contoso,dc=com" -p subtree -r "(objectCategory=organizationalUnit)" -l "cn,objectclass,ou"


ldifde -f c:\temp\Exportuser.ldf -s tjadp01 -d "dc=contoso,dc=com" -p subtree -r "(&(objectCategory=person)(objectClass=User)(givenname=*))" -l "cn,givenName,objectclass,samAccountName"