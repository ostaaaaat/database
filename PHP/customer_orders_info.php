<head>
<title>Заказы</title>
</head>
<a href="confectioners.php">Кондитеры</a><a href="packages.php">Упаковки</a><a href="customer_orders_info.php">[А]Заказы</a><a href="report.php">[А]Отчет</a>
<br>
<?php
pg_connect("host=localhost dbname=confectionery user=postgres password=nwraa2002jj");


if(isset($_POST['customer_id'])){
	$customer_orders = pg_query('select order_id from orders where customer_id = '.$_POST['customer_id']);
    while ($row = pg_fetch_assoc($customer_orders)) {
		$row_id = $row['order_id'];
		$query = <<<EOS
			SELECT date_of_receipt_of_the_order,
            SUM(number_of_order_product_category * product_categories.price) AS sum_product_categories,
            SUM(number_of_product_category_internal_components * internal_components.price) AS sum_internal_components,
            packages.price AS price_packages, SUM((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price) AS summa,
            SUM(((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price)*discount_size) AS discount,
            SUM(((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price) - (((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price)*discount_size)) as itogo
            FROM orders_product_categories
            JOIN orders ON orders.order_id=orders_product_categories.order_id
            JOIN product_categories ON product_categories.product_category_id=orders_product_categories.product_category_id
            JOIN product_categories_internal_components ON orders_product_categories.product_category_id=product_categories_internal_components.product_category_id
            JOIN internal_components ON internal_components.internal_components_id=product_categories_internal_components.internal_components_id
            JOIN discounts ON orders.discount_id=discounts.discount_id
            JOIN packages ON orders.package_id=packages.package_id
            WHERE orders.order_id = $row_id
            GROUP BY date_of_receipt_of_the_order, product_categories.name, number_of_order_product_category, product_categories.price, internal_components.name, 
            number_of_product_category_internal_components, internal_components.price, discount_size, packages.type, packages.price
EOS;
        $orders_sum_info[] = pg_fetch_assoc(pg_query($query));
    }
}


$customers = pg_query("select * from customers");
echo '
	<br>
    <form action="customer_orders_info.php" method="post">
        <select name="customer_id" onchange="this.form.submit()">
        ';
        while ($customer = pg_fetch_assoc($customers)) {
            echo '<option value="'.$customer['customer_id'].'" ';
			if(isset($_POST['customer_id']) && $_POST['customer_id']==$customer['customer_id']) {
				echo 'selected';
			}
			echo '>'.$customer['name'].'</option>';
        }
echo '  </select>
    </form>';
	
if (isset($orders_sum_info)) {
	echo '
	<table>
    <tr>
        <th>Дата заказа</th>
        <th>Итоговая сумма заказа</th>
    </tr>';
	
	 foreach($orders_sum_info as $order) {
	 	echo'
	 	<tr>
	 		<td>'.$order['date_of_receipt_of_the_order'].'</td>
	 		<td>'.$order['itogo'].'</td>
	 	</tr>';
	 }
	echo '</table>';
}
?>
