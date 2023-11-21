/*
    Написать функцию, которая удаляет всю информацию об указанном пользователе из БД vk. Пользователь задается по id. Удалить нужно все сообщения, лайки, медиа записи, профиль и запись из таблицы users. Функция должна возвращать номер пользователя.
*/

DELIMITER //

CREATE FUNCTION DeleteUserFunc (user_id_del INT)
RETURNS INT
BEGIN

    DELETE 
    FROM `vk`.`likes` l
    WHERE l.user_id = user_id_del;
    
    DELETE 
    FROM `vk`.`users_communities` uc
    WHERE uc.user_id = user_id_del;
    
    DELETE 
    FROM `vk`.`messages` m
    WHERE m.to_user_id = user_id_del 
        OR m.from_user_id = user_id_del;
    
    DELETE 
    FROM `vk`.`friend_requests` fr
    WHERE fr.initiator_user_id = user_id_del 
        OR fr.target_user_id = user_id_del;

    DELETE l
    FROM `vk`.`media` m
    JOIN `vk`.`likes` l ON l.media_id = m.id
    WHERE m.user_id = user_id_del;
    
    UPDATE `vk`.`profiles` p
    JOIN `vk`.`media` m ON p.photo_id = m.id
    SET p.photo_id = NULL
    WHERE m.user_id = user_id_del;

    DELETE 
    FROM `vk`.`media` m
    WHERE m.user_id = user_id_del;

    DELETE 
    FROM `vk`.`profiles` p
    WHERE p.user_id = user_id_del;
    
    DELETE 
    FROM `vk`.`users` u
    WHERE u.id = user_id_del;
    
    RETURN user_id_del;

END; // 

DELIMITER ;

SELECT DeleteUserFunc(1) AS user_id_del;

/*
    Предыдущую задачу решить с помощью процедуры и обернуть используемые команды в транзакцию внутри процедуры.
*/

DELIMITER //

CREATE PROCEDURE DeleteUserProc (user_id_del INT)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    
    BEGIN
        ROLLBACK;
    END;

	START TRANSACTION;
    
		DELETE 
        FROM `vk`.`likes` l
		WHERE l.user_id = user_id_del;
    
		DELETE 
        FROM `vk`.`users_communities` uc
		WHERE uc.user_id = user_id_del;
    
		DELETE 
        FROM `vk`.`messages` m
		WHERE m.to_user_id = user_id_del 
            OR m.from_user_id = user_id_del;
    
		DELETE 
        FROM `vk`.`friend_requests` fr
		WHERE fr.initiator_user_id = user_id_del 
            OR fr.target_user_id = user_id_del;
    
		DELETE l
		FROM `vk`.`media` m
		JOIN `vk`.`likes` l ON l.media_id = m.id
		WHERE m.user_id = user_id_del;
    
		UPDATE `vk`.`profiles` p
		JOIN `vk`.`media` m ON p.photo_id = m.id
		SET p.photo_id = NULL
		WHERE m.user_id = user_id_del;

		DELETE 
        FROM `vk`.`media` m
		WHERE m.user_id = user_id_del;
    
		DELETE 
        FROM `vk`.`profiles` p
		WHERE p.user_id = user_id_del;
    
		DELETE 
        FROM `vk`.`users` u
		WHERE u.id = user_id_del;
         
	COMMIT;

END; // 

DELIMITER ;

