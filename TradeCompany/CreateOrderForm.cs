using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Configuration;

namespace TradeCompany
{
    public partial class CreateOrderForm : Form
    {
        /// <summary>
        /// Проверяет не был ли добавлен один товар дважды
        /// </summary>
        private bool[] wasAdded;
        public CreateOrderForm()
        {
            InitializeComponent();
        }

        /// <summary>
        /// Получение строки подключение из App.config
        /// </summary>
        /// <param name="name">Имя строки подключения из App.config</param>
        /// <returns></returns>
        static string GetConnectionStringByName(string name)
        {
            // Assume failure.
            string returnValue = null;

            // Look for the name in the connectionStrings section.
            ConnectionStringSettings settings =
                ConfigurationManager.ConnectionStrings[name];

            // If found, return the connection string.
            if (settings != null)
                returnValue = settings.ConnectionString;

            return returnValue;
        }

        /// <summary>
        /// Инициализация comboBox значениями из столбца таблицы типа Int
        /// </summary>
        /// <param name="comboBox">Объект comboBox</param>
        /// <param name="columnName">Имя столбца таблицы</param>
        /// <param name="tableName">Имя таблицы</param>
        private void InitializeComboBoxInt(ComboBox comboBox, string columnName, string tableName)
        {
            List<int> listAgents = new List<int>();
            using (SqlConnection con = new SqlConnection(GetConnectionStringByName("ConnectionStringToDatabase")))
            {
                using (SqlCommand command = new SqlCommand("SELECT DISTINCT " + columnName + " FROM " + tableName, con))
                {
                    con.Open();

                    using (SqlDataReader dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            listAgents.Add(dataReader.GetInt32(0));
                        }
                    }
                }
            }
            comboBox.DataSource = listAgents;
        }

        /// <summary>
        /// Инициализация comboBox значениями из столбца таблицы типа String
        /// </summary>
        /// <param name="comboBox">Объект comboBox</param>
        /// <param name="columnName">Имя столбца таблицы</param>
        /// <param name="tableName">Имя таблицы</param>
        private void InitializeComboBoxString(ComboBox comboBox, string columnName, string tableName)
        {
            List<string> listAgents = new List<string>();
            using (SqlConnection con = new SqlConnection(GetConnectionStringByName("ConnectionStringToDatabase")))
            {
                using (SqlCommand command = new SqlCommand("SELECT DISTINCT " + columnName + " FROM " + tableName, con))
                {
                    con.Open();

                    using (SqlDataReader dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            listAgents.Add(dataReader.GetString(0));
                        }
                    }
                }
            }
            comboBox.DataSource = listAgents;
        }

        private void label4_Click(object sender, EventArgs e)
        {

        }

        /// <summary>
        /// Добавление всех строк datagrid в таблицу order
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void button2_Click(object sender, EventArgs e)
        {
            if (dataGridView1.RowCount == 0)
            {
                MessageBox.Show("Введите список товаров");
            }
            else
            {
                using (SqlConnection con = new SqlConnection(GetConnectionStringByName("ConnectionStringToDatabase")))
                {
                    con.Open();
                    foreach (DataGridViewRow row in dataGridView1.Rows)
                    {
                        if (row.IsNewRow){
                            break;
                        }
                        //whatever you are currently doing
                        using (SqlCommand command2 = new SqlCommand("create_order", con))
                        {
                            // get vender code for this procedure

                            command2.CommandType = CommandType.StoredProcedure;

                            command2.Parameters.Add("@good_name", SqlDbType.VarChar);
                            command2.Parameters["@good_name"].Value = row.Cells[0].Value.ToString();// Получить из строки;

                            command2.Parameters.Add("@order_id", SqlDbType.Int);
                            command2.Parameters["@order_id"].Value = comboBox1.SelectedValue;//.. получить из строки vender_code;

                            command2.Parameters.Add("@total", SqlDbType.Int);
                            command2.Parameters["@total"].Value = row.Cells[1].Value;

                            command2.ExecuteNonQuery();
                        }
                    }
                    MessageBox.Show("Товары были добавлены в документ");

                }
            }
            
        }

        private void CreateOrderForm_Load(object sender, EventArgs e)
        {
            InitializeComboBoxInt(comboBox1, "document_num", "CreditOrder");
            InitializeComboBoxString(comboBox2, "name", "Goods");

            wasAdded = new bool[comboBox2.Items.Count];

            dataGridView1.ColumnCount = 2;
            dataGridView1.Columns[0].HeaderText = "Good";
            dataGridView1.Columns[1].HeaderText = "total";
        }

        /// <summary>
        /// Добавление нового товара в список
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void button1_Click(object sender, EventArgs e)
        {
            if (numericUpDown1.Value <= 0)
            {
                MessageBox.Show("Количество должно быть больше нуля");
                return;
            }
            else
            {
                if (wasAdded[comboBox2.SelectedIndex])
                {
                    MessageBox.Show("Данный товар уже был добавлен");
                }
                else
                {
                    dataGridView1.Rows.Add(comboBox2.SelectedValue, numericUpDown1.Value);
                    wasAdded[comboBox2.SelectedIndex] = true;
                }
            }
        }
    }
}
