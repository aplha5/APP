from flask import Flask, redirect, url_for, render_template, request

app = Flask(__name__)

@app.route("/")
def home():
    return render_template("index.html", content = "sir")

@app.route("/<name>")
def user(name):
    return f"Hello {name}!"

@app.route("/hello")
def us():
    return render_template("hello.html", content = "hola")

@app.route("/admin")
def admin():
    return redirect(url_for("home"))

@app.route("/login", methods = ["POST", "GET"])
def login():
    if request.method == "POST":
        user = request.form["nm"]
        return redirect(url_for("user", usr= user))
    else:
        return render_template("login.html")

if __name__ == "__main__":
    app.run(debug = True)
