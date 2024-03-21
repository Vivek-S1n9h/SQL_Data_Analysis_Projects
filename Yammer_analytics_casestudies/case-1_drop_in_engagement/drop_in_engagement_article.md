
# Case 1: Investigating a Drop in User Engagement

## Intro:

Yammer is a social network for communicating with coworkers. Individuals share documents, updates, and ideas by posting them in groups. Yammer is free to use indefinitely, but companies must pay license fees if they want access to administrative controls, including integration with user management systems like ActiveDirectory.

You can refer [here](https://mode.com/sql-tutorial/a-drop-in-user-engagement) for the case study and data or go to my [github](https://github.com/Vivek-S1n9h/SQL_Data_Analysis_Projects) to reference my queries.

## The problem

**what caused the dip at the end of the chart shown below?**

![weekly_active_users_chart](/Yammer_analytics_casestudies/case-1_drop_in_engagement/weekly_active_users_chart.PNG)

## Listing possible causes

* **Technical Isuues:** The dip can be due to some bugs, glitches, or server downtimes may hinder users' ability to access the platform, leading to decreased engagement and retention. For Example, the code that logs events, is itself broken.
* **Competition/:** One of the most common cause is increased competition from other social networking or collaboration tools offering similar features could attract users away from Microsoft Teams.
* **User Interface changes:** Updates or redesigns to the user interface (UI) or user experience (UX) may confuse or frustrate existing users, causing them to disengage from the platform.
* **Lack of new features:** Users may become disinterested if there's a lack of innovative or useful new features being introduced regularly.
* **Security concerns:** Data breaches or concerns over privacy and security could lead users to abandon or reduce their usage of the platform.
* **Lack of Training or support**:  Insufficient training or support for new users may result in frustration and decreased engagement with the platform.
* **Seasonal Trends**: Fluctuations in usage due to seasonal factors, such as holidays or vacation periods, may lead to temporary dips in retention. For example, when Super Bowl Ad increased signups then user retention seen a massive decrease due to seasonal end. 
* **Users need Mismatch:** fails to adequately address the specific collaboration needs or workflows of its target users, they may seek alternative solutions.
* **Performance issues:** If the mobile app version of Microsoft Teams is experiencing performance issues or lacks features compared to the desktop version, users may use it less frequently.
* **Integration issues:** Difficulties in integrating Microsoft Teams with other essential tools or platforms used by organizations may lead to decreased adoption and retention.
* **Market Saturity:** The market for social networking and collaboration tools may become saturated, making it challenging for Microsoft Teams to maintain user interest and retention levels.

## Priortizing:

There can be lot of possibilities, so it's important to move through them in the most efficient order possible.

## Data Model:

### Table 1: Users
This table includes one row per user, with descriptive information about that user's account.

This table name is tutorial.yammer_users
* **user_id**:	A unique ID per user. Can be joined to user_id in either of the other tables.
* **created_at**:	The time the user was created (first signed up)
* **state**:	The state of the user (active or pending)
* **activated_at**:	The time the user was activated, if they are active
* **company_id**:	The ID of the user's company
* **language**:	The chosen language of the user

### Table 2: Events
This table includes one row per event, where an event is an action that a user has taken on Yammer. These events include login events, messaging events, search events, events logged as users progress through a signup funnel, events around received emails.

This table name is tutorial.yammer_events
* **user_id**:	The ID of the user logging the event. Can be joined to user\_id in either of the other tables.
* **occurred_at**:	The time the event occurred.
* **event_type**:	The general event type. There are two values in this dataset: "signup_flow", which refers to anything occuring during the process of a user's authentication, and "engagement", which refers to general product usage after the user has signed up for the first time.
* **event_name**:	The specific action the user took. Possible values include: create_user: User is added to Yammer's database during signup process enter_email: User begins the signup process by entering her email address enter_info: User enters her name and personal information during signup process complete_signup: User completes the entire signup/authentication process home_page: User loads the home page like_message: User likes another user's message login: User logs into Yammer search_autocomplete: User selects a search result from the autocomplete list search_run: User runs a search query and is taken to the search results page search_click_result_X: User clicks search result X on the results page, where X is a number from 1 through 10. send_message: User posts a message view_inbox: User views messages in her inbox
* **location**:	The country from which the event was logged (collected through IP address).
* **device**:	The type of device used to log the event.

### Table 3: Email Events
This table contains events specific to the sending of emails. It is similar in structure to the events table above.

This table name is tutorial.yammer_emails
* **user_id**:	The ID of the user to whom the event relates. Can be joined to user_id in either of the other tables.
* **occurred_at**:	The time the event occurred.
* **action**:	The name of the event that occurred. "sent_weekly_digest" means that the user was delivered a digest email showing relevant conversations from the previous day. "email_open" means that the user opened the email. "email_clickthrough" means that the user clicked a link in the email.

### Table 4: Rollup Periods
The final table is a lookup table that is used to create rolling time periods. Though you could use the INTERVAL() function, creating rolling time periods is often easiest with a table like this. You won't necessarily need to use this table in queries that you write, but the column descriptions are provided here so that you can understand the query that creates the chart shown above.

This table name is benn.dimension_rollup_periods
* **period_id**:	This identifies the type of rollup period. The above dashboard uses period 1007, which is rolling 7-day periods.
* **time_id**:	This is the identifier for any given data point — it's what you would put on a chart axis. If time_id is 2014-08-01, that means that is represents the rolling 7-day period leading up to 2014-08-01.
* **pst_start**:	The start time of the period in PST. For 2014-08-01, you'll notice that this is 2014-07-25 — one week prior. Use this to join events to the table.
* **pst_end**:	The start time of the period in PST. For 2014-08-01, the end time is 2014-08-01. You can see how this is used in conjunction with pst_start to join events to this table in the query that produces the above chart.
* **utc_start**:	The same as pst_start, but in UTC time.
* **pst_start**:	The same as pst_end, but in UTC time.

