#!/bin/bash

#Compare pages from different URLs/sources (For example)
​
WEB_TEXT_1=www.amazon.com
WEB_TEXT_2=www.amazon.ca
WEB_TEXT_3=www.amazon.co.uk
WEB_TEXT_4=www.amazon.in

CURRENT_FOLDER=$(pwd)

#Below the pages to compare to among them. This script is very useful to compare Endeca rules that have to match from different sources (for example)
​
page_1='Macbeth-Folger-Shakespeare-Library-William/dp/0743477103/ref=sr_1_1?ie=UTF8&qid=1495591580&sr=8-1&keywords=macbeth+book'
page_2='Love-Time-Cholera-Oprahs-Book/dp/0307389731/ref=sr_1_1?ie=UTF8&qid=1495591328&sr=8-1&keywords=love+in+times+of+cholera'
page_3='Holy-Bible-King-James-Version/dp/0310941784/ref=sr_1_2?ie=UTF8&qid=1495591872&sr=8-2&keywords=bible'

​
PAGES_TO_COMPARE=($page_1 $page_2 $page_3)
​
#You can create a written printable report.
rm -f  $CURRENT_FOLDER/printresults.txt
​
for j in ${PAGES_TO_COMPARE[*]}; do
​
echo "Comparing,  it is going to take a while so be patient please!"
echo "analizing page" $j
echo "analizing page" $j >> printresults.txt

#start by counting the number of words amog pages. If pages are different the wc will be the first indicator.

count_WEB1=$(wc --words <(curl -s --fail --connect-timeout 5 https://$WEB_TEXT_1/$j) | awk '{print $1}') 
count_WEB2=$(wc --words <(curl -s --fail --connect-timeout 5 https://$WEB_TEXT_2/$j) | awk '{print $1}') 
count_WEB3=$(wc --words <(curl -s --fail --connect-timeout 5 https://$WEB_TEXT_3/$j) | awk '{print $1}') 
count_WEB4=$(wc --words <(curl -s --fail --connect-timeout 5 https://$WEB_TEXT_4/$j) | awk '{print $1}')
​
if [ "$count_WEB2" -ne "$count_WEB1" ]; then
​
echo "$WEB_TEXT_2 vs $WEB_TEXT_1"
echo "$WEB_TEXT_2 vs $WEB_TEXT_1" >> printresults.txt

#The diff command will tell you where the differents are if they exists.

diff -w -B --text -q --ignore-matching-lines=sessionId --ignore-matching-lines=eneTime --ignore-matching-lines=assemblyStartTimestamp  --ignore-matching-lines=assemblyFinishTimestamp <(curl -s --fail --connect-timeout 5 https://$WEB_TEXT_1/$j) <(curl -s --fail --connect-timeout 5 https://$WEB_TEXT_2/$j) >> printresults.txt
​​
fi
​
if [ "$count_WEB3" -ne "$count_WEB1" ]; then
​
echo "$WEB_TEXT_3 vs $WEB_TEXT_1"
echo "$WEB_TEXT_3 vs $WEB_TEXT_1" >> printresults.txt
diff -w -B --text -q --ignore-matching-lines=sessionId --ignore-matching-lines=eneTime --ignore-matching-lines=assemblyStartTimestamp  --ignore-matching-lines=assemblyFinishTimestamp <(curl -s --fail --connect-timeout 5 https://$WEB_TEXT_1/$j) <(curl -s --fail --connect-timeout 5 https://$WEB_TEXT_3/$j) >> printresults.txt
​​
fi
​
if [ "$count_WEB4" -ne "$count_WEB1" ]; then
​
echo "$WEB_TEXT_4 vs $WEB_TEXT_1"
echo "$WEB_TEXT_4 vs $WEB_TEXT_1" >> printresults.txt
diff -w -B --text -q --ignore-matching-lines=sessionId --ignore-matching-lines=eneTime --ignore-matching-lines=assemblyStartTimestamp  --ignore-matching-lines=assemblyFinishTimestamp <(curl -s --fail --connect-timeout 5 https://$WEB_TEXT_1/$j) <(curl -s --fail --connect-timeout 5 https://$WEB_TEXT_4/$j) >> printresults.txt
​​
fi
done
echo "DONE!"