DELIMITER //
CREATE FUNCTION jdate(ts VARCHAR(8))
    RETURNS INTEGER(10)
    READS SQL DATA
    DETERMINISTIC
    BEGIN
		
        DECLARE g_y VARCHAR(4);
				DECLARE g_m VARCHAR(2);
				DECLARE g_d VARCHAR(2);
				
				DECLARE gy INTEGER(10);
				DECLARE gm INTEGER(10);
				DECLARE gd INTEGER(10);
				
				DECLARE jy INTEGER(10);
				DECLARE jm INTEGER(10);
				DECLARE jd INTEGER(10);
				
				DECLARE g_day_no INTEGER(10);
				DECLARE j_day_no INTEGER(10);
				DECLARE j_np INTEGER(10);
						
				DECLARE g_days_in_month VARCHAR (255) ;
				DECLARE g_days_in_month_element INTEGER(10);
				
				DECLARE j_days_in_month VARCHAR(255); 
				DECLARE j_days_in_month_element INTEGER(10);
				
				DECLARE i INTEGER(10);
				DECLARE outputData INTEGER(10);
				
				SET g_days_in_month = '31,28,31,30,31,30,31,31,30,31,30,31';
				SET j_days_in_month = '31,31,31,31,31,31,30,30,30,30,30,29';
				
				SET g_y = SUBSTR(ts FROM 1 FOR 4);
				SET g_m = SUBSTR(ts FROM 5 FOR 2);
				SET g_d = SUBSTR(ts FROM 7 FOR 2);
				
				SET gy = g_y - 1600;
        SET gm = g_m - 1;
        SET gd = g_d - 1;
				
				SET g_day_no = (365 * gy) + ((gy + 3) DIV 4) - ((gy + 99) DIV 100) + ((gy + 399) DIV 400);
				
				SET i = 1;
				
				WHILE i < gm + 1 DO
					SET g_days_in_month_element = SUBSTRING_INDEX(g_days_in_month, ',', 1);
					SET g_day_no = g_day_no + g_days_in_month_element ;
					SET g_days_in_month = SUBSTRING(g_days_in_month, LOCATE(',', g_days_in_month) + 1);
					SET i = i + 1;
				END WHILE;
				
				IF ( gm > 1 && (( gy % 4 = 0 && gy % 100 != 0) || ( gy % 400 = 0))) THEN
					SET g_day_no = g_day_no + 1 ;
				END IF;
				
				SET g_day_no = g_day_no + gd ;
				SET j_day_no = g_day_no - 79 ;
				SET j_np = j_day_no DIV 12053;
				SET j_day_no = j_day_no % 12053 ;
				SET jy = 979 + 33 * j_np + 4 * (j_day_no DIV 1461);
				SET j_day_no = j_day_no % 1461;
				
				IF (j_day_no >= 366) THEN
					SET jy = jy + ((j_day_no - 1) DIV 365);
					SET j_day_no = (j_day_no - 1) % 365;
				END IF;
				
				SET i = 1 ;
				SET j_days_in_month_element = SUBSTRING_INDEX(j_days_in_month, ',', 1);
				SET j_days_in_month = SUBSTRING(j_days_in_month, LOCATE(',', j_days_in_month) + 1);
				
				WHILE ((i < 12) && (j_day_no >= j_days_in_month_element)) DO
					IF (i > 1) THEN
						SET j_days_in_month_element = SUBSTRING_INDEX(j_days_in_month, ',', 1);
						SET j_days_in_month = SUBSTRING(j_days_in_month, LOCATE(',', j_days_in_month) + 1);
					END IF;
					SET j_day_no = j_day_no - j_days_in_month_element ;
					SET i = i + 1;
				END WHILE;
				
				SET jm = i ;
				SET jd = j_day_no + 1 ;

				SET outputData = (10000 * jy) + (100 * jm) + (jd) ;
				
				RETURN outputData;
    END
//
DELIMITER ;
