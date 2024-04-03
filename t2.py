from flask import Flask, redirect, url_for, render_template, request, session, flash
from datetime import timedelta
from flask_mysqldb import MySQL

app = Flask(__name__)
app.secret_key = "HolaCopa"
app.permanent_session_lifetime = timedelta(minutes= 5)
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'Jethru24'
app.config['MYSQL_DB'] = 'octacore'

mysql = MySQL(app)
@app.route("/")
def home():
    return render_template("index.html")

@app.route('/user', methods=['GET', 'POST'])
def user():
    if "user" in session:
        user = session["user"]
        if request.method == 'POST':
            search_term = request.form['search_term']
            search_by = request.form['search_by']  # This should be either 'Name/Email' or 'Discipline/Section'

            cur = mysql.connection.cursor()

            query= '''SELECT * FROM ((SELECT CONCAT_WS(' ', ts.FirstName, ts.MiddleName, ts.LastName) AS Name, jd.Designation AS Designation, ts.Email AS Email,jd.Discipline_name AS Discipline_Section, p.Work AS Work,CONCAT_WS('/', IFNULL(p.Home, ''), IFNULL(p.Emergency, '')) AS Home_Emerg, CONCAT_WS('/', jd.Building, jd.Room_number) AS Office FROM Teaching_staff ts JOIN Specialization s ON ts.Faculty_ID = s.Faculty_ID JOIN Job_desc jd ON s.Discipline_name = jd.Discipline_name JOIN Contact c ON ts.Faculty_ID = c.Faculty_ID JOIN Phone p ON c.Work = p.Work AND s.Designation = jd.Designation AND s.Room_number = jd.Room_number AND s.Building = jd.Building) UNION All (SELECT CONCAT_WS(' ', nts.F_name, nts.M_name, nts.L_name) AS Name, jd.Designation AS Designation, nts.EmailID AS Email, jd.Discipline_name AS Discipline_Section, p.Work AS Work, CONCAT_WS('/', IFNULL(p.Home, ''), IFNULL(p.Emergency, '')) AS Home_Emerg, CONCAT_WS('/', jd.Building, jd.Room_number) AS Office  FROM NTeaching_staff nts  JOIN Work_info wi ON nts.Staff_ID = wi.Staff_ID JOIN Job_desc jd ON wi.Discipline_name = jd.Discipline_name JOIN Contact_enquiry ce ON nts.Staff_ID = ce.Staff_ID JOIN Phone p ON ce.Work = p.Work AND wi.Designation = jd.Designation AND wi.Room_number = jd.Room_number AND wi.Building = jd.Building) UNION All (SELECT CONCAT_WS(' ', st.First_name, st.Middle_name, st.Last_name) AS Name, st.Program AS Designation,st.Email_id AS Email,st.Discipline AS Discipline_Section,p.Work AS Work,CONCAT_WS('/', IFNULL(p.Home, ''), IFNULL(p.Emergency, '')) AS Home_Emerg, CONCAT_WS('/',' ') AS Office  FROM Students st  JOIN Contact_number cn ON st.Roll_number = cn.Roll_number  JOIN Phone p ON cn.Work = p.Work) UNION All (SELECT CONCAT_WS(' ', f.Facility_name) AS Name,' ' AS Designation, f.Email_addr AS Email,' ' AS Discipline_Section, p.Work AS Work, CONCAT_WS('/', IFNULL(p.Home, ''), IFNULL(p.Emergency, '')) AS Home_Emerg, CONCAT_WS('/', f.BuildingName, f.RoomNumber) AS Office  FROM Contact_info ci  JOIN Facility f ON ci.Facility_name = f.Facility_name   JOIN Phone p ON ci.Work = p.Work) UNION All (SELECT b.Block_name AS Name, ' ' AS Designation,' ' AS Email,' ' AS Discipline_Section,p.Work AS Work, CONCAT_WS('/', IFNULL(p.Home, ''), IFNULL(p.Emergency, '')) AS Home_Emerg, ' '  AS Office  FROM To_Contact tc  JOIN Block b ON tc.Block_name = b.Block_name  JOIN Phone p ON tc.Work = p.Work)) AS derived_table'''
            
            data = []

            if search_by == 'Name/Email':
                cur.execute(query + " WHERE Name LIKE %s OR Email LIKE %s ORDER BY Name", (f"%{search_term}%", f"%{search_term}%"))
            else:  # search_by == 'Discipline/Section'
                cur.execute(query + " WHERE Discipline_Section LIKE %s ORDER BY Name", (f"%{search_term}%",))

            data.extend(cur.fetchall())

            cur.close()

            return render_template('index1.html', data=data)

        return render_template('index1.html')
    
    else:
        flash("You are not logged In!")
        return redirect(url_for("login"))

@app.route("/login", methods = ["POST", "GET"])
def login():
    if request.method == "POST":
        session.permanent = True
        user = request.form["nm"]
        session["user"] = user
        flash("Login Successful!")
        return redirect(url_for("user"))
    else:
        if "user" in session:
            flash("Already Logged In!")
            return redirect(url_for("user"))
        
        return render_template("login.html")


@app.route("/logout")
def logout():
    flash("You have been logged out!", "info")
    session.pop("user", None)
    return redirect(url_for("login"))

@app.route("/insert", methods = ["POST", "GET"])
def insert():
    if request.method == 'POST':
        table_name = request.form['table_name']
        attributes = request.form.getlist('attributes')
        values = request.form.getlist('values')

        cur = mysql.connection.cursor()

        query = f"INSERT INTO {table_name} ({', '.join(attributes)}) VALUES ({', '.join(['%s'] * len(values))})"
        cur.execute(query, values)
        mysql.connection.commit()

        cur.close()

        return render_template('insert.html', message="Data inserted successfully!")

    return render_template("insert.html")

@app.route('/delete', methods=['GET','POST'])
def delete():
    if request.method == 'POST':
        table_name = request.form['table_name']
        attribute_names = request.form.getlist('attribute_names[]')
        attribute_values = request.form.getlist('attribute_values[]')

        cur = mysql.connection.cursor()

        conditions = [f"{name} = '{value}'" for name, value in zip(attribute_names, attribute_values) if name and value]
        if conditions:
            condition_str = ' AND '.join(conditions)
            query = f"DELETE FROM {table_name} WHERE {condition_str}"
            cur.execute(query)
            mysql.connection.commit()

        cur.close()

        return render_template('delete.html', message="Data deleted successfully!")

    return render_template('delete.html')

@app.route('/update', methods=['GET', 'POST'])
def update():
    if request.method == 'POST':
        table_name = request.form['table_name']
        attribute_names = request.form.getlist('attribute_names[]')
        attribute_values = request.form.getlist('attribute_values[]')
        update_attribute = request.form['update_attribute']
        update_value = request.form['update_value']

        cur = mysql.connection.cursor()

        conditions = [f"{name} = '{value}'" for name, value in zip(attribute_names, attribute_values) if name and value]
        if conditions:
            condition_str = ' AND '.join(conditions)
            query = f"UPDATE {table_name} SET {update_attribute} = '{update_value}' WHERE {condition_str}"
            cur.execute(query)
            mysql.connection.commit()
            cur.close()
            return render_template('update.html', message="Data updated successfully!")

    return render_template('update.html')


if __name__ == "__main__":
    app.run(debug = True)
