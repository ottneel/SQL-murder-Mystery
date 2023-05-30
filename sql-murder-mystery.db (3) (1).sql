--Open the Crime_scene_report--
select description 
from crime_scene_report
where type="murder" and date =20180115 and city="SQL City";

-- Query the person table to get the details of the first witness--
select *
from person
where address_street_name
like "Northwestern Dr"
order by address_number DESC
Limit 1;

--Query the interview table to get the testimony from the first witness--
select transcript, name as first_witness
from interview
inner join person on person_id = id
where address_number=4919;

-- Query the person table to get the details of the second witness--
select *
from person
where name like "Annabel%" and address_street_name= "Franklin Ave";

--Nested Query that first gets the name in the where clause and then uses it to get the transcript.(the interview table is joined with the person table--
select transcript, name as second_witness
from interview
inner join person on person_id = id
where name in (
  select name
  from person
  where name like 'Annabel%' and address_street_name= 'Franklin Ave');

-- is Annabel's gym the get_fit_now gym?--
select person_id,membership_start_date,membership_status, gym.name as gym_members
from get_fit_now_member as gym
inner join person
on gym.person_id=person.id
where gym_members = 'Annabel Miller';

--search for members with description as given by the first witness--
select membership_id,check_in_date,name,membership_status
from get_fit_now_check_in
inner join get_fit_now_member on membership_id=id
where membership_status= "gold" and membership_id like "48Z%";


--defined a CTE named suspects and used it to join the persons and drivers_license table to get the suspect with a plate of H42W--
WITH suspects AS (
    SELECT membership_id,person_id, check_in_date, name, membership_status
    FROM get_fit_now_check_in
    INNER JOIN get_fit_now_member ON membership_id = id
    WHERE membership_status = 'gold' AND membership_id LIKE '48Z%'
)
select person_id, person.name, person.license_id,gender, plate_number
from suspects
inner join person on suspects.person_id= person.id
inner join drivers_license on person.license_id = drivers_license.id
where plate_number like "_H42W_";

-- To check if Jeremy was at the gym a week before the murder as said by the second witness--
select check_in_date, name, membership_status 
from get_fit_now_check_in
inner join get_fit_now_member on membership_id=id
where person_id= 67318;

--getting the details of the killer--
select * from drivers_license inner join person on license_id=drivers_license.id where person.id = 67318;

--this proves that Jeremy Bowers is the killer and the police could begin by going to his house on Washington Pl, Apt 3A and putting an alert on his car license plate--

--to verify--
INSERT INTO solution(user,value )
VALUES (1, 'Jeremy Bowers');

select * from solution

-- theres still more...--
select transcript, name as suspect
from interview
inner join person on person_id = id
where address_number=530;

--Cte to get the description of persons from Jeremy's testimony--
with Mastermind_descrip as (
  	select gender, drivers_license.id, height,hair_color,car_make,car_model
	from drivers_license
	where (height between 65 and 67) and (hair_color= 'red') and (car_make = 'Tesla') and (car_model = 'Model S')
),

-- Cte to check the Ids of those who attended the Sql symphony Concert--
Mastermind_event as (
  select distinct facebook_event_checkin.person_id
  from facebook_event_checkin
  where event_name='SQL Symphony Concert'  and facebook_event_checkin.date like '201712%'
)

-- join the two tables to get the killer--

SELECT person.name as Mastermind_killer
from person
INNER join Mastermind_descrip on person.license_id =  Mastermind_descrip.id
inner join Mastermind_event on person.id= Mastermind_event.person_id;

--To further check Jeremeys testimony--
select gender, drivers_license.id, height,hair_color,car_make,car_model,person.id,person.license_id,person.name
from drivers_license
INNER join person on person.license_id =  drivers_license.id
where (height between 65 and 67) and (hair_color= 'red') and (car_make = 'Tesla') and (car_model = 'Model S')

select facebook_event_checkin.person_id as person_iid, facebook_event_checkin.date, event_name,count(person_id) as no_of_attending, name, person.id, drivers_license.id
from facebook_event_checkin
inner join person on facebook_event_checkin.person_id=person.id
inner join drivers_license on person.license_id=drivers_license.id
where event_name='SQL Symphony Concert'  and facebook_event_checkin.date like '201712%'
group by facebook_event_checkin.person_id
HAVING no_of_attending >=3

-- check the suspects id
select * from
drivers_license
where id = 202298

-- to verify--
INSERT INTO solution(user,value )
VALUES (1, 'Miranda Priestly');

select * from solution
-- Miranda priestly is the Master Mind behind the killings