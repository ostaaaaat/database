<head>
<title>Отчет</title>
</head>
<a href="confectioners.php">Кондитеры</a><a href="packages.php">Упаковки</a><a href="customer_orders_info.php">[А]Заказы</a><a href="report.php">[А]Отчет</a>
<br>
<?php
pg_connect("host=localhost dbname=confectionery user=postgres password=nwraa2002jj");


if(isset($_POST['month'])){
	$month_post = $_POST['month'];
    $query = <<<EOS
            SELECT date_of_receipt_of_the_order,
            product_categories.name AS product_category, number_of_order_product_category AS count_product_categories, product_categories.price AS price_product_categories, SUM(number_of_order_product_category * product_categories.price) AS sum_product_categories,
            internal_components.name AS internal_components, number_of_product_category_internal_components AS count_internal_components, internal_components.price AS price_internal_components, SUM(number_of_product_category_internal_components * internal_components.price) AS sum_internal_components,
            discount_size, packages.type, packages.price AS price_packages, SUM((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price) AS summa,
            SUM(((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price)*discount_size) AS discount,
            SUM(((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price) - (((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price)*discount_size)) AS "itogo"
            FROM orders_product_categories
            JOIN orders ON orders.order_id=orders_product_categories.order_id
            JOIN product_categories ON product_categories.product_category_id=orders_product_categories.product_category_id
            JOIN product_categories_internal_components ON orders_product_categories.product_category_id=product_categories_internal_components.product_category_id
            JOIN internal_components ON internal_components.internal_components_id=product_categories_internal_components.internal_components_id
            JOIN discounts ON orders.discount_id=discounts.discount_id
            JOIN packages ON orders.package_id=packages.package_id
            WHERE date_of_receipt_of_the_order>='01.$month_post.2022' AND date_of_receipt_of_the_order<='28.$month_post.2022' 
            GROUP BY date_of_receipt_of_the_order, product_categories.name, number_of_order_product_category, product_categories.price, internal_components.name, 
            number_of_product_category_internal_components, internal_components.price, discount_size, packages.type, packages.price
EOS;
    $report = pg_query($query);
    
}


$customers = pg_query("select * from customers");
echo '
	<br>
    <form action="report.php" method="post">
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
        <th>Дата заказа</th>
        <th>Изделие</th>
		<th>Количество</th>
		<th>Сумма по категориям изделий</th>
        <th>Начинка</th>
		<th>Сумма по начинкам</th>
        <th>Цена упаковки</th>
		<th>Скидка</th>
        <th>Итоговая сумма заказа</th>
    </tr>';
	
	 while ($row = pg_fetch_assoc($report)) {
	 	echo'
	 	<tr>
	 		<td>'.$row['date_of_receipt_of_the_order'].'</td>
	 		<td>'.$row['product_category'].'</td>
			<td>'.$row['count_product_categories'].'</td>
			<td>'.$row['sum_product_categories'].'</td>
	 		<td>'.$row['internal_components'].'</td>
			<td>'.$row['sum_internal_components'].'</td>
	 		<td>'.$row['price_packages'].'</td>
			<td>'.$row['discount'].'</td>
	 		<td>'.$row['itogo'].'</td>
	 	</tr>';
	 }
	echo '</table>';
}
?>
