# mysql-jalali-date-converter
Converts gregorian calender date to Jalali date.

after running the script to use the function you can write the query like:

SELECT
	jdate ( from_unixtime( 0, '%Y%m%d' ) )
  
  
  
  0 is the unix timestamp
