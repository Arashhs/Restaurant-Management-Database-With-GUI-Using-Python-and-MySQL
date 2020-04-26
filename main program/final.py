import tkinter as tk
from tkinter import *
from tkinter import ttk
import mysql.connector
from tabulate import tabulate
import webbrowser



class App:
    def __init__(self):
        db = mysql.connector.connect(
            host="localhost",
            user="root",
            passwd="",
            database="citado"
        )
        cursor = db.cursor()





        cursor.execute("show tables")

        tables = [item[0] for item in cursor.fetchall()]
        print("Select a table:")

        for i in range(len(tables)):
            print(i, tables[i])

        tab = comboBox(tables, "Choose a table")
        stmt = "describe " + tables[tab]
        print(stmt)
        cursor.execute(stmt)
        headers = [item[0] for item in cursor.fetchall()]

        print(headers)
        stmt = "select * from " + tables[tab]
        cursor.execute(stmt)
        result = [item for item in cursor.fetchall()]
        for i in range(len(result)):
            print(result[i])

        def show():
            listBox.delete(*listBox.get_children())
            stmt = "select * from " + tables[tab]
            cursor.execute(stmt)
            result = [item for item in cursor.fetchall()]
            tempList = result
            for i in range(len(tempList)):
                listBox.insert("", "end", values=result[i])

        def insert():
            stmt = "Insert into " + tables[tab] + " values("
            tmpres = ''
            for i in range(len(headers)):
                tmpres = entries[i].get()
                if isSelectable(i):
                    cp = entries[i].current()
                    tmpres = str(blist1[getProperBlist(i)][cp])
                if isSelectable2(i):
                    cp = entries[i].current()
                    tmpres = str(blist2[cp])
                if tmpres == '' or tmpres == 'None':
                    tmpres = 'null'
                else:
                    tmpres = "'" + tmpres + "'"
                stmt += tmpres
                stmt += ", "
            stmt = stmt[:-2]
            stmt += ")"
            print(stmt)
            cursor.execute(stmt)
            db.commit()
            show()

        backupRow = []
        def update():
            stmt = "update " + tables[tab] + " set "
            tmpres = ''
            for i in range(len(headers)):
                tmpres = entries[i].get()
                if isSelectable(i):
                    cp = entries[i].current()
                    tmpres = str(blist1[getProperBlist(i)][cp])
                if isSelectable2(i):
                    cp = entries[i].current()
                    tmpres = str(blist2[cp])
                if tmpres == '' or tmpres == 'None':
                    tmpres = 'null'
                else:
                    tmpres = "'" + tmpres + "'"
                stmt += headers[i] + "=" + tmpres + ", "
            stmt = stmt[:-2]
            stmt += " Where "
            print(backupRow)
            for i in range(len(headers)):
                tmpres = backupRow[i]
                if tmpres == '' or tmpres == 'None':
                    tmpres = 'null'
                else:
                    tmpres = "'" + tmpres + "'"
                if tmpres == 'null':
                    stmt += headers[i] + " is null and "
                    continue
                stmt += headers[i] + "=" + tmpres + " and "
            stmt = stmt[:-4]
            print(stmt)
            cursor.execute(stmt)
            db.commit()
            show()

        def delete():
            stmt = "delete from " + tables[tab] + " where "
            print(backupRow)
            tmpres = ''
            for i in range(len(headers)):
                tmpres = backupRow[i]
                if tmpres == '' or tmpres == 'None':
                    tmpres = 'null'
                else:
                    tmpres = "'" + tmpres + "'"
                if tmpres == 'null':
                    stmt += headers[i] + " is null and "
                    continue
                stmt += headers[i] + "='" + backupRow[i] + "' and "
            stmt = stmt[:-4]
            print(stmt)
            cursor.execute(stmt)
            db.commit()
            show()


        def onClick(event):
            backupRow.clear()
            item = listBox.identify("item", event.x, event.y)
            print(listBox.item(item, 'values'))
            ins = listBox.item(item, 'values')
            for i in range(len(ins)):
                print(ins[i])
                backupRow.append(ins[i])
                entries[i].delete(0, END)
                entries[i].insert(0, ins[i])

        def isSelectable(i):
            if tables[tab] == 'orders' and (headers[i] == 'AID' or headers[i] == 'customerID' or headers[i] == 'courierID'):
                return TRUE
            return FALSE

        def getProperBlist(i):
            if headers[i] == 'AID':
                return 0
            elif headers[i] == 'courierID':
                return 1
            elif headers[i] == 'customerID':
                return 2

        def isSelectable2(i):
            if (tables[tab] == 'shoporder' or tables[tab] == 'shoporder_items') and (headers[i] == 'SID'):
                return TRUE
            return FALSE




        self.root = tk.Tk()
        self.tree = ttk.Treeview()
      #  Entry(self.root, textvariable=mystring).grid(row=0, column=1, sticky=E)  # entry textbox
        showTable = self.root
        showTable.title("9631019 - Arash Hajisafi")
        label = tk.Label(showTable, text=tables[tab], font=("Arial", 30)).grid(row=0, columnspan=len(headers))
        label2 = tk.Label(showTable, text="                      ")    .grid(row=4, columnspan=len(headers))
        label3 = tk.Label(showTable, text="                      ")    .grid(row=6, columnspan=len(headers))
        # create Treeview with 3 columns
        cols = headers
        self.tree = ttk.Treeview(showTable, columns=headers, show='headings')
        listBox = self.tree
        # set column headings
        for col in cols:
            listBox.heading(col, text=col)
        listBox.grid(row=10, column=0, columnspan=len(headers))
        show()
        entries = []

        blist1 = [[], [], []]
        blist2 = []
        for i in range(len(headers)):
            if isSelectable(i):
                if headers[i] == 'AID':
                    stmt = "select * from address"
                    cursor.execute(stmt)
                    resultset = [item for item in cursor.fetchall()]
                    resultset.insert(0, "None")
                    blist1[0] = [item[0] for item in resultset]
                    blist1[0][0] = "None"
                    print(resultset)
                    entries.append(ttk.Combobox(showTable, values=resultset))
                    entries[i].grid(row=5, column=i)
                    continue
                elif headers[i] == 'courierID':
                    stmt = "select * from courier"
                    cursor.execute(stmt)
                    resultset = [item for item in cursor.fetchall()]
                    resultset.insert(0, "None")
                    blist1[1] = [item[1] for item in resultset]
                    blist1[1][0] = "None"
                    print(resultset)
                    entries.append(ttk.Combobox(showTable, values=resultset))
                    entries[i].grid(row=5, column=i)
                    continue
                elif headers[i] == 'customerID':
                    stmt = "select * from customer"
                    cursor.execute(stmt)
                    resultset = [item for item in cursor.fetchall()]
                    resultset.insert(0, "None")
                    blist1[2] = [item[0] for item in resultset]
                    blist1[2][0] = "None"
                    print(resultset)
                    entries.append(ttk.Combobox(showTable, values=resultset))
                    entries[i].grid(row=5, column=i)
                    continue
            elif isSelectable2(i):
                stmt = "select * from shop"
                cursor.execute(stmt)
                resultset = [item for item in cursor.fetchall()]
                k = 0
                lim = len(resultset)
                while k < lim:
                    if resultset[k][2] == 'inactive':
                        del resultset[k]
                        lim -= 1
                        k -= 1
                    k += 1
                resultset.insert(0, "None")
                blist2 = [item[0] for item in resultset]
                blist2[0] = 'None'
                print(resultset)
                print(blist2)
                entries.append(ttk.Combobox(showTable, values=resultset))
                entries[i].grid(row=5, column=i)
                continue

            entries.append(Entry(self.root))
            entries[i].grid(row=5, column= i)

        updateButton = tk.Button(showTable, text="Update", width=15, command=update).grid(row=1, column=0)
        closeButton = tk.Button(showTable, text="Close", width=15, command=exit).grid(row=3, column=len(headers)-1)
        deleteButton = tk.Button(showTable, text="Delete", width=15, command=delete).grid(row=1, column=len(headers)-1)
        insertButton = tk.Button(showTable, text="Insert", width=15, command=insert).grid(row=3, column=0)


        listBox.bind("<ButtonRelease-1>", onClick)
        self.root.mainloop()
        db.close()


def comboBox(optionset, title):
    global option
    option = 0
    app = tk.Tk()
    app.geometry('300x100')

    labelTop = tk.Label(app,
                        text="What do you want to do?")
    labelTop.grid(column=0, row=0)

    comboExample = ttk.Combobox(app,
                                values=optionset)

    comboExample.grid(column=0, row=1)
    comboExample.current(0)

    def initMenu():
        global option
        option = comboExample.current()
        app.destroy()

    optionButton = tk.Button(app, text="OK", width=15, command=initMenu).grid(row=2, column=0)
    exitButton = tk.Button(app, text="Exit", width=15, command=exit).grid(row=3, column=0)
    app.grid_rowconfigure(0, weight=1)
    app.grid_columnconfigure(0, weight=1)

    app.title(title)
    app.mainloop()
    return option


def printReportBeautifully(cursor, title, headersnames, f):
    f.write(title)
    f.write("\n")
    print(title)
    myresult = cursor.fetchall()
    finalres = tabulate(myresult, headers=headersnames, tablefmt='psql')
    print(finalres)
    f.write(finalres)
    f.write("\n\n\n")
    print("\n")



def generateReports():
    db = mysql.connector.connect(
        host="localhost",
        user="root",
        passwd="",
        database="citado"
    )
    cursor = db.cursor()

    f = open("report.txt", "w")

    cursor.execute("""select om.foodName, sum(om.unit) as total_sold, avg(om.price) as unit_price, date (o.orderDate) as on_date
    from order_menu om, orders o
    where om.orderID = o.orderID
    group by om.foodName, date(o.orderDate)
    order by on_date;""")

    printReportBeautifully(cursor, "Total Sales", ['foodName', 'total_sold', 'unit_price', 'on_date'], f)

    cursor.execute("""select o.orderID, sum(om.unit * om.price) as total_price, date(orderDate) as on_Date from order_menu om, orders o where om.orderID = o.orderID group by o.orderID""")

    printReportBeautifully(cursor, "Income for each menu-order", ['orderID', 'total_price', 'on_date'], f)

    cursor.execute("""select on_date, sum(total_price) as total_income from
    (select o.orderID, sum(om.unit * om.price) as total_price, date(orderDate) as on_Date from order_menu om, orders o where om.orderID = o.orderID group by o.orderID) as day_order
    group by on_date""")

    printReportBeautifully(cursor, 'Total income for each day', ['on_date', 'total_income'], f)

    cursor.execute("""select so.orderID, sum(soi.unit * soi.Iprice) as order_cost, date(orderDate) as on_Date
    from shoporder so, shopOrder_Items soi
    where so.orderID = soi.orderID
    group by so.orderID""")

    printReportBeautifully(cursor, 'Order cost for each order from shop', ['orderID', 'order_cost', 'on_date'], f)

    cursor.execute("""select on_date, sum(total_price) as total_spent from
    (
    select so.orderID, sum(soi.unit * soi.Iprice) as total_price, date(orderDate) as on_Date
    from shoporder so, shopOrder_Items soi
    where so.orderID = soi.orderID
    group by so.orderID ) as day_spent
    group by on_date""")

    printReportBeautifully(cursor, 'Total spent on each day for shop orders', ['on_date', 'total_spent'], f)

    cursor.execute("""select spent.on_Date, total_income, total_spent, (total_income - total_spent) as profit
    from (select on_date, sum(total_price) as total_income from
    (select o.orderID, sum(om.unit * om.price) as total_price, date(orderDate) as on_Date from order_menu om, orders o where om.orderID = o.orderID group by o.orderID) as day_order
    group by on_date) as incomes
    , (select on_date, sum(total_price) as total_spent from
    (
    select so.orderID, sum(soi.unit * soi.Iprice) as total_price, date(orderDate) as on_Date
    from shoporder so, shopOrder_Items soi
    where so.orderID = soi.orderID
    group by so.orderID ) as day_spent
    group by on_date) as spent
    where incomes.on_Date = spent.on_Date""")

    printReportBeautifully(cursor, 'Profit for each day', ['on_date', 'total_income', 'total_spent', 'profit'], f)

    cursor.execute("""select c.CID, c.FName, c.LName, om.foodName, sum(om.unit) as times_ordered from order_menu om, orders o, customer c
    where om.orderID = o.orderID and o.customerID = c.CID
    group by cid, foodName;""")

    printReportBeautifully(cursor, 'Ordered food for each customer', ['customerID', 'First_name', 'Last_name', 'foodName', 'times_ordered'], f)

    cursor.execute("""select  user_orders.CID, FName, LName, foodName as most_ordered_food, times_ordered
    from (
        select max(times_ordered) as max_ordered_times, CID
        from (
            select c.CID, c.FName, c.LName, om.foodName, sum(om.unit) as times_ordered from order_menu om, orders o, customer c
            where om.orderID = o.orderID and o.customerID = c.CID
            group by cid, foodName) as user_orders
            group by CID
        ) as user_orders,
         (
        select c.CID, c.FName, c.LName, om.foodName, sum(om.unit) as times_ordered from order_menu om, orders o, customer c
        where om.orderID = o.orderID and o.customerID = c.CID
        group by cid, foodName
             ) as ordered
    where ordered.times_ordered = max_ordered_times and ordered.CID = user_orders.CID;""")

    printReportBeautifully(cursor, 'Food most ordered by each user', ['customerID', 'First_name', 'Last_name', 'most_oredered_food', 'times_ordered'], f)

    db.close()
    f.close()
    webbrowser.open("report.txt")


def removeTables():
        db = mysql.connector.connect(
            host="localhost",
            user="root",
            passwd="",
            database="citado"
        )
        cursor = db.cursor()



        cursor.execute("show tables")

        tables = [item[0] for item in cursor.fetchall()]
        print("Select a table to remove:")

        for i in range(len(tables)):
            print(i, tables[i])

        tab = comboBox(tables, "Select table to remove")
        stmt = "drop table " + tables[tab]
        print(stmt)
        cursor.execute(stmt)
        db.commit()
        print("Table",tables[tab],"removed")
        db.close()

def createTable():
    db = mysql.connector.connect(
        host="localhost",
        user="root",
        passwd="",
        database="citado"
    )
    cursor = db.cursor()

    fields = 'Table name', 'Attributes', 'Constraints'

    def mktable():
        stmt = ""
        stmt += "create table "
        stmt += ents[0].get()
        stmt += "(" + ents[1].get()
        if ents[2].get() != "":
            stmt += ", "
        stmt += ents[2].get() + ")"
        print(stmt)
        cursor.execute(stmt)
        db.commit()
        root.destroy()

    def makeform(root, fields):
        entries = []
        for field in fields:
            row = tk.Frame(root)
            lab = tk.Label(row, width=15, text=field, anchor='w')
            ent = tk.Entry(row)
            row.pack(side=tk.TOP, fill=tk.X, padx=5, pady=5)
            lab.pack(side=tk.LEFT)
            ent.pack(side=tk.RIGHT, expand=tk.YES, fill=tk.X)
            entries.append(ent)
        return entries

    root = tk.Tk()
    ents = makeform(root, fields)

    b1 = tk.Button(root, text='Create Table', command=mktable)
    b1.pack(side=tk.LEFT, padx=5, pady=5)
    b2 = tk.Button(root, text='Quit', command=root.destroy)
    b2.pack(side=tk.LEFT, padx=5, pady=5)
    root.mainloop()

    db.close()




if __name__ == "__main__":
    while TRUE:
        firstOption = ["Show and Edit tables", "Get reports", "Remove tables", "Create tables"]

        option = comboBox(firstOption, "Select an option")
        if option == 0:
            app = App()
        elif option == 1:
            generateReports()
        elif option == 2:
            print("remove table")
            removeTables()
        elif option == 3:
            print("create table")
            createTable()
