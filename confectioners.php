<head>
<title>Кондитеры</title>
</head>
<a href="confectioners.php">Кондитеры</a><a href="packages.php">Упаковки</a><a href="customer_orders_info.php">[А]Заказы</a><a href="report.php">[А]Отчет</a>
<br>
<?php
pg_connect("host=localhost dbname=confectionery user=postgres password=nwraa2002jj");

if(isset($_POST['delete_confectioner_id'])){
	pg_query('delete from confectioners where confectioner_id = '.$_POST['delete_confectioner_id']);
}

if(isset($_POST['update_confectioner_id'])){
	pg_query("update confectioners set name = '".$_POST['confectioner_name']."', confectionery_id = '".$_POST['confectionery_id']."' where confectioner_id = ".$_POST['update_confectioner_id']);
}

if(isset($_POST['create_confectioner_id'])){
	pg_query("insert into confectioners(\"name\", \"confectionery_id\") values ('".$_POST['confectioner_name']."','".$_POST['confectionery_id']."')");
}

$orders = pg_query("select cr.confectioner_id as confectioner_id, cr.name as name, cy.address as address from confectioners as cr join confectioneries as cy on cy.confectionery_id = cr.confectionery_id order by cr.confectioner_id asc");
echo '
	<a href="confectioners_update.php" class="button">➕</a>
	<br>
	<table>
    <tr>
        <th>Имя</th>
        <th>Адрес кондитерской</th>
		<th></th>
    </tr>';
	while ($row = pg_fetch_assoc($orders)) {
		echo'
		<tr>
			<td>'.$row['name'].'</td>
			<td>'.$row['address'].'</td>
			<td>
				<form action="confectioners.php" method="POST">
					<button name="delete_confectioner_id" value="'.$row['confectioner_id'].'">🗑️</button>
				</form>
			</td>
			<td>
				<form action="confectioners_update.php" method="POST">
					<button name="confectioner_id" value="'.$row['confectioner_id'].'">✏️</button>
				</form>
			</td>
		</tr>';
	}
	echo '</table>';
?>