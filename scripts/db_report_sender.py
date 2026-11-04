from email.message import EmailMessage
from db import _QUERY_PATH, get_sql_query, get_list_of_target_views, get_list_of_query_text, fetch_data_as_df
from config import Config
from pathlib import Path
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import psycopg2
from config import Config
from jinja2 import Template
import webbrowser

## Getting df for email reports

str_views_query = str(get_sql_query(_QUERY_PATH))
list_of_target_views = get_list_of_target_views(str_views_query)
list_of_view_queries_text = get_list_of_query_text(list_of_target_views)

# HTML-example of letter

HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: Arial, sans-serif; color: #333; background-color: #f4f6f9; padding: 20px; }
        .card { background: #ffffff; padding: 25px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); max-width: 700px; margin: auto; }
        h2 { color: #2c3e50; margin-top: 0; border-bottom: 2px solid #ecf0f1; padding-bottom: 12px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { padding: 10px 12px; text-align: left; border-bottom: 1px solid #ecf0f1; font-size: 14px; }
        th { background-color: #f8f9fa; color: #333; font-weight: bold; }
        tr:hover { background-color: #f1f2f6; }
        .footer {
        clear: both;          
        width: 100%;          
        text-align: center;   
        margin-top: 40px;     
        padding-top: 15px;
        border-top: 1px solid #e1e4e8;
        color: #6a737d;
        font-size: 12px;
    }
    </style>
</head>
<body>
    <div class="cards" >
        <div class="card">
            <h2>📊 Olist Logistics & Delivery Delay Digest</h2>
            <p>Automated analysis of overdue delivery categories, affected order volume, and average 
            delay duration extracted from the PostgreSQL database:</p>
            
            <table>
                <thead>
                    <tr>
                        <th>Period of report</th>
                        <th>Overdue category</th>
                        <th>Order amount</th>
                        <th>Total value</th>
                        <th>Avg days</th>
                    </tr>
                </thead>
                <tbody>
                    {% for row in overdue_orders_summary %}
                    <tr>
                        <td>{{ row.report_period }}</td>
                        <td>{{ row.overdue_category }}</td>
                        <td>{{ row.order_count }}</td>
                        <td>{{ row.total_value }}</td>
                        <td>{{ row.avg_days }}</td>
                    </tr>
                    {% endfor %}
                </tbody>
            </table>
        </div>
        <div class="card">
            <h2>📊 Olist Monthly Financial & Revenue Digest</h2>
            <p>Automated summary of monthly order volume, item revenue, freight costs, gross revenue, 
            and Average Order Value (AOV) extracted directly from PostgreSQL:</p>
            
            <table>
                <thead>
                    <tr>
                        <th>Report period</th>
                        <th>Orders</th>
                        <th>Items revenue</th>
                        <th>Freight value</th>
                        <th>Cross revenue</th>
                        <th>Aov</th>
                    </tr>
                </thead>
                <tbody>
                    {% for row in month_revenue_aov %}
                    <tr>
                        <td>{{ row.report_period }}</td>
                        <td>{{ row.orders }}</td>
                        <td>{{ row.items_revenue }}</td>
                        <td>{{ row.freight_value }}</td>
                        <td>{{ row.cross_revenue }}</td>
                        <td>{{ row.aov }}</td>
                    </tr>
                    {% endfor %}
                </tbody>
            </table>
        </div>
        <div class="card">
            <h2>📊 Olist Payment Methods & Transaction Share Digest</h2>
            <p>Automated analysis of payment channel distribution, transaction counts, 
            volume shares, and total monetary value extracted directly from PostgreSQL:</p>
            
            <table>
                <thead>
                    <tr>
                        <th>Report period</th>
                        <th>Payment type</th>
                        <th>Total transaction</th>
                        <th>Volume avg</th>
                        <th>Share of volume</th>
                        <th>Total volume</th>
                    </tr>
                </thead>
                <tbody>
                    {% for row in payment_method %}
                    <tr>
                        <td>{{ row.report_period }}</td>
                        <td>{{ row.payment_type }}</td>
                        <td>{{ row.total_transaction }}</td>
                        <td>{{ row.volume_avg }}</td>
                        <td>{{ row.share_of_volume_pct }}</td>
                        <td>{{ row.total_volume }}</td>
                    </tr>
                    {% endfor %}
                </tbody>
            </table>
        </div>
        <div class="card">
            <h2>📊 Olist Operational & Logistics Performance Digest</h2>
            <p>Automated breakdown of fulfillment delays, payment channel distribution, revenue metrics,
             and freight costs extracted directly from PostgreSQL:</p>
            
            <table>
                <thead>
                    <tr>
                        <th>Customer state</th>
                        <th>Order count</th>
                        <th>Avg item price</th>
                        <th>Avg freight value</th>
                        <th>Freight share</th>
                        <th>Case</th>
                    </tr>
                </thead>
                <tbody>
                    {% for row in freight_ratio %}
                    <tr>
                        <td>{{ row.customer_state }}</td>
                        <td>{{ row.order_count }}</td>
                        <td>{{ row.avg_item_price }}</td>
                        <td>{{ row.avg_freight_value }}</td>
                        <td>{{ row.freight_share }}</td>
                        <td>{{ row.case }}</td>
                    </tr>
                    {% endfor %}
                </tbody>
            </table>
        </div>
            
        <div class="footer">
                <p>Automatically generated by your Data Engineering pipeline (Python + PostgreSQL + Jinja2).</p>
        </div>
    </div>
</body>
</html>
"""



if __name__ == "__main__":
    try:
    ## Loading df for gmail report

        queries = {
            'overdue_orders_summary': list_of_view_queries_text[0],
            'month_revenue_aov': list_of_view_queries_text[1],
            'payment_method': list_of_view_queries_text[2],
            'freight_ratio': list_of_view_queries_text[3],
        }

        reports_data = {
            key: fetch_data_as_df(query, db_url=Config.DB_URL).to_dict(orient='records')
            for key, query in queries.items()
        }


        # Render HTML template with data
        template = Template(HTML_TEMPLATE)

        rendered_html = template.render(reports_data)
        # --- LOCAL PREVIEW STEP ---
        preview_file = Path("preview_report.html")
        preview_file.write_text(rendered_html, encoding="utf-8")
    except Exception as e:
        print(f"❌ Error executing the pipeline: {e}")

    ## Sending reports
    msg = EmailMessage()
    msg["From"] = Config.SMTP_CONFIG['sender_email']
    msg["To"] = Config.SMTP_CONFIG['receiver_email']
    msg["Subject"] = "Olist Monthly Financial report"
    msg.set_content("")
    msg.add_alternative("<p></p>", subtype="html")

    with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
        server.login(Config.SMTP_CONFIG['sender_email'], Config.SMTP_CONFIG['app_password'])
        server.send_message(msg)
