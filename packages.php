<head>
<title>Упаковки</title>
</head>
<a href="confectioners.php">Кондитеры</a><a href="packages.php">Упаковки</a><a href="customer_orders_info.php">[А]Заказы</a><a href="report.php">[А]Отчет</a>
<br>
<?php
pg_connect("host=localhost dbname=confectionery user=postgres password=nwraa2002jj");

if(isset($_POST['delete_package_id'])){
	pg_query('delete from packages where package_id = '.$_POST['delete_package_id']);
}

if(isset($_POST['update_package_id'])){
	pg_query("update packages set type = '".$_POST['package_type']."', price = '".$_POST['price']."' where package_id = ".$_POST['update_package_id']);
}

if(isset($_POST['create_package_id'])){
	pg_query("insert into packages(\"type\", \"price\") values ('".$_POST['package_type']."','".$_POST['price']."')");
}

$packages = pg_query("select * from packages order by package_id asc");
echo '
	<a href="packages_update.php" class="button">➕</a>
	<br>
	<table>
    <tr>
        <th>Тип</th>
        <th>Цена</th>
		<th></th>
    </tr>';
	while ($row = pg_fetch_assoc($packages)) {
		echo'
		<tr>
			<td>'.$row['type'].'</td>
			<td>'.$row['price'].'</td>
			<td>
				<form action="packages.php" method="POST">
					<button name="delete_package_id" value="'.$row['package_id'].'">🗑️</button>
				</form>
			</td>
			<td>
				<form action="packages_update.php" method="POST">
					<button name="package_id" value="'.$row['package_id'].'">✏️</button>
				</form>
			</td>
		</tr>';
	}
	echo '</table>';
?>