

use projects;

-- what is the gender breakdown of employees in the company?  
select gender, count(*) as count
from hr
where age>=18 and termdate='0000-00-00'
group by gender;

-- what is the race/ethnicity breakdown of employees in the company?
select race, count(*) as count
from hr
where age>=18 and termdate='0000-00-00'
group by race
order by count(*) desc;

-- what is the age distribution of employees iin the company?
select 
	min(age) as youngest,
    max(age) as oldest
from hr
where age>18 and termdate='0000-00-00';

select 
	case
		when age>18 and age<24 then '18-24'
        when age>25 and age<34 then '25-34'
        when age>35 and age<44 then '35-44'
        when age>45 and age<54 then '45-54'
        when age>55 and age<64 then '55-64'
        else '65+'
	end as age_group,
    count(*) as count from hr
    where age>18 and termdate='0000-00-00'
    group by age_group
    order by age_group;
    
-- how many employees work at headquaters versus remote location?
select location,count(*) as count
from hr
where age>=18 and termdate='0000-00-00'
group by location;

-- what is the average length of employment for employees who have been terminsted?
select round(avg(datediff(termdate,hire_date))/365,0) as avg_length_employement
from hr
where age>=18 and termdate<>'0000-00-00' and termdate<curdate();

-- how does the gender distribution vary across departments and job titles?
select department, gender, count(*) as count
from hr
where age>=18 and termdate='0000-00-00'
group by department, gender
order by department;

-- what is the distribution of job titles across the company?
select jobtitle, count(*) as count
from hr
where age>=18 and termdate='0000-00-00'
group by jobtitle
order by jobtitle desc;

-- which department has the highest turnover rate?
select department, total_count,terminated_count,
terminated_count/total_count as termination_rate
from(
	select department,
		count(*) as total_count,
        sum(case when termdate<>'0000-00-00' and termdate<curdate() then 1 else 0 end) as terminated_count
        from hr
        where age>=18
        group by department
        ) as subquery
order by termination_rate desc;

-- what is the distribution of employees across location by city and state?
select location_state, count(*) as count
from hr
where age>=18 and termdate='0000-00-00'
group by location_state
order by count desc;

-- how has the company's employee count changed over time based on hire and term date?
select yaer,
	hires,
    terminations,
    hires-terminations as net_change,
    round((hires-terminations)/hires * 100, 2) as net_change_percent
from (
	select year(hire_date) as yaer,
    count(*) as hires,
    sum(case when termdate<>'0000-00-00' and termdate<curdate() then 1 else 0 end) as terminations
    from hr
    where age>=18
    group by year(hire_date)
    ) as subquery
order by yaer asc;

-- what is the tenure distribution for each department?
select department, round(avg(datediff(termdate,hire_date)/365),0) as avg_tenure
from hr
where termdate<curdate() and termdate<>'0000-00-00' and age>=18
group by department;