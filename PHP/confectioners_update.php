<head>
<title>Кондитеры</title>
</head>
<a href="confectioners.php" >Назад</a>
<br>
<?php
pg_connect("host=localhost dbname=confectionery user=postgres password=nwraa2002jj");

$current_confectioner = array('name' => '', 'confectionery_id' => '');
if(isset($_POST['confectioner_id'])){
	$current_confectioner = pg_fetch_assoc(pg_query('select * from confectioners where confectioner_id = '.$_POST['confectioner_id']));
}

echo '
	
	<form action="confectioners.php" method="POST">
		<input type="text" name="confectioner_name" value="'.$current_confectioner['name'].'">Имя<br>';
$confectioneries = pg_query("select * from confectioneries");
echo '
		<br>
        <select name="confectionery_id">
        ';
        while ($confectionery = pg_fetch_assoc($confectioneries)) {
            echo '<option value="'.$confectionery['confectionery_id'].'" ';
			if(isset($_POST['confectionery_id']) && $_POST['confectionery_id']==$customer['confectionery_id']) {
				echo 'selected';
			}
			echo '>'.$confectionery['address'].'</option>';
        }
echo '  </select> Адрес кондитерской <br>';
		if(isset($_POST['confectioner_id'])){
			echo '<button name="update_confectioner_id" value="'.$_POST['confectioner_id'].'">Сохранить</button>';
		} else {
			echo '<button name="create_confectioner_id" value="0">Сохранить</button>';
		}
echo '
	</form>
	'
?>
