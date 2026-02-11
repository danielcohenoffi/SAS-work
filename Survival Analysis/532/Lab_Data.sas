   /* lab example 2 */

   data shoulder;
      input area $ location $ size $ usage $ count @@;
      datalines;
   coast    urban large  no 174 coast    urban large  yes 69 
   coast    urban medium no 134 coast    urban medium yes 56 
   coast    urban small  no 150 coast    urban small  yes 54 
   coast    rural large  no  52 coast    rural large  yes 14 
   coast    rural medium no  31 coast    rural medium yes 14 
   coast    rural small  no  25 coast    rural small  yes 17 
   piedmont urban large  no 127 piedmont urban large  yes 62 
   piedmont urban medium no  94 piedmont urban medium yes 63 
   piedmont urban small  no 112 piedmont urban small  yes 93 
   piedmont rural large  no  35 piedmont rural large  yes 29 
   piedmont rural medium no  32 piedmont rural medium yes 30 
   piedmont rural small  no  46 piedmont rural small  yes 34 
   mountain urban large  no 111 mountain urban large  yes 26 
   mountain urban medium no 120 mountain urban medium yes 47 
   mountain urban small  no 145 mountain urban small  yes 68 
   mountain rural large  no  62 mountain rural large  yes 31 
   mountain rural medium no  44 mountain rural medium yes 32 
   mountain rural small  no  85 mountain rural small  yes 43 
   ;



   /* lab example 3 */

   data school;
      input school program $ style $ count @@; 
      datalines;
   1 regular  self 10  1 regular  team 17 1 regular class   26
   1 after    self  5  1 after    team 12 1 after   class   50 
   2 regular  self 21  2 regular  team 17 2 regular class   26
   2 after    self 16  2 after    team 12 2 after   class   36 
   3 regular  self 15  3 regular  team 15 3 regular class   16
   3 after    self 12  3 after    team 12 3 after   class   20 
   ; 

