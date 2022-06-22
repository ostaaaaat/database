<head>
<title>Изделия</title>
</head>
<a href="confectioners.php">Кондитеры</a><a href="packages.php">Упаковки</a><a href="customer_orders_info.php">[А]Заказы</a><a href="report.php">[А]Отчет</a><a href="cake_size.php">[А]Торты</a><a href="categories.php">[А]Изделия</a><a href="components.php">[А]Наполнения</a>
<br>
<?php
pg_connect("host=localhost dbname=confectionery user=postgres password=nwraa2002jj");


if(isset($_POST['month'])){
	$month_post = $_POST['month'];
    $query = <<<EOS
            SELECT internal_components.name AS "name", COUNT(product_categories_internal_components.internal_components_id) AS "count" 
FROM product_categories_internal_components
JOIN internal_components ON internal_components.internal_components_id=product_categories_internal_components.internal_components_id
JOIN orders_product_categories ON orders_product_categories.product_category_id=product_categories_internal_components.product_category_id 
JOIN orders ON orders.order_id=orders_product_categories.order_id
WHERE orders.date_of_receipt_of_the_order>='01.$month_post.2022' AND orders.date_of_receipt_of_the_order<='28.$month_post.2022' 
GROUP BY product_categories_internal_components.internal_components_id, internal_components.name ORDER BY "count" DESC LIMIT 3;
EOS;
    $report = pg_query($query);
    
}

echo '
	<br>
    <form action="components.php" method="post">
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
        <th>Наименование</th>
        <th>Количество</th>
    </tr>';
	
	 while ($row = pg_fetch_assoc($report)) {
	 	echo'
	 	<tr>
	 		<td>'.$row['name'].'</td>
	 		<td>'.$row['count'].'</td>
	 	</tr>';
	 }
	echo '</table>';
}
?>
