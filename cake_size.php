<head>
<title>Торты</title>
</head>
<a href="confectioners.php">Кондитеры</a><a href="packages.php">Упаковки</a><a href="customer_orders_info.php">[А]Заказы</a><a href="report.php">[А]Отчет</a><a href="cake_size.php">[А]Торты</a>
<br>
<?php
pg_connect("host=localhost dbname=confectionery user=postgres password=nwraa2002jj");


if(isset($_POST['month'])){
	$month_post = $_POST['month'];
    $query = <<<EOS
            SELECT product_categories.size, COUNT(product_categories.size) AS "count" FROM orders_product_categories
JOIN product_categories ON product_categories.product_category_id=orders_product_categories.product_category_id 
JOIN orders ON orders.order_id=orders_product_categories.order_id
WHERE orders.date_of_receipt_of_the_order>='01.$month_post.2022' AND orders.date_of_receipt_of_the_order<='28.$month_post.2022' 
GROUP BY product_categories.size ORDER BY "count" DESC LIMIT 1;
EOS;
    $report = pg_query($query);
    
}

echo '
	<br>
    <form action="cake_size.php" method="post">
        <select name="month" onchange="this.form.submit()">
        ';
        for ($i = 1; $i < 13; $i++){
            $month = sprintf("%02s", $i);
            echo '<option value="'.$month.'" ';
			if(isset($_POST['month']) && $_POST['month']==$month) {
				echo 'selected';
			}
			echo '>'.DateTime::createFromFormat('!m', $i)->format('F').'</option>';
        }
echo '  </select>
    </form>';
	
if (isset($report)) {
	echo '
	<table>
    <tr>
        <th>Размер</th>
        <th>Количество</th>
    </tr>';
	
	 while ($row = pg_fetch_assoc($report)) {
	 	echo'
	 	<tr>
	 		<td>'.$row['size'].'</td>
	 		<td>'.$row['count'].'</td>
	 	</tr>';
	 }
	echo '</table>';
}
?>