using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Configuration;

namespace TradeCompany
{
    public partial class Form1 : Form
    {
        private SqlConnection SqlConnection = null;

        private SqlCommandBuilder SqlCommandBuilder = null;

        private SqlDataAdapter sqlDataAdapter = null;

        private DataSet dataSet = null;

        private string currentTable;

        private bool newRowAdding = false;
        /// <summary>
        /// ключ - название таблицы
        /// значение - количество столбцов 
        /// </summary>
        private Dictionary<string, int> numberOfColumns = 
            new Dictionary<string, int> { {"CreditOrder", 5 },
                                          {"Order_list",  4 }, 
                                          {"Goods",       4 } };

        private int lastIndexTable = 2; // меняется в зависимости от таблицы

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

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            SqlConnection = new SqlConnection(GetConnectionStringByName("ConnectionStringToDatabase"));

            SqlConnection.Open();

        }

        /// <summary>
        /// Получить таблицу из базы данных и заполнить dataGrid
        /// </summary>
        /// <param name="tableName">Имя таблицы</param>
        private void GetAndFillTable(string tableName)
        {
            int value = -1;
            if (numberOfColumns.TryGetValue(tableName, out value))
            {
                lastIndexTable = value;
                currentTable = tableName;
                LoadData();
            }
            else
            {
                MessageBox.Show($"Таблица {tableName} не найдена", "Ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
        /// <summary>
        /// Получение данных из таблицы "CreditOrder"
        /// </summary>
        private void button1_Click(object sender, EventArgs e)
        {
            GetAndFillTable("CreditOrder");
        }

        /// <summary>
        /// Получение данных из таблицы "Order_list"
        /// </summary>
        private void button2_Click(object sender, EventArgs e)
        {
            GetAndFillTable("Order_list");
        }
        /// <summary>
        /// Получение данных из таблицы "Goods"
        /// </summary>
        private void button3_Click(object sender, EventArgs e)
        {
            GetAndFillTable("Goods");
        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {

        }

        /// <summary>
        /// Получение данных из базы и заполнение таблицы
        /// </summary>
        private void LoadData()
        {
            try
            {
                sqlDataAdapter = new SqlDataAdapter("Select *, 'Delete' AS [Delete] FROM " + currentTable, SqlConnection);

                SqlCommandBuilder = new SqlCommandBuilder(sqlDataAdapter);

                SqlCommandBuilder.GetInsertCommand();
                SqlCommandBuilder.GetUpdateCommand();
                SqlCommandBuilder.GetDeleteCommand();

                dataSet = new DataSet();

                sqlDataAdapter.Fill(dataSet, currentTable);

                dataGridView1.DataSource = null;
                dataGridView1.DataSource = dataSet.Tables[currentTable];

                for (int i = 0; i < dataGridView1.Rows.Count; i++)
                {

                    DataGridViewLinkCell linkCell = new DataGridViewLinkCell();
                    dataGridView1[lastIndexTable, i] = linkCell;
                }

                dataGridView1.Refresh();
                dataGridView1.Update();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        /// <summary>
        /// Обновление данных таблицы
        /// </summary>
        private void ReloadData()
        {
            try
            {
                dataSet.Tables[currentTable].Clear();

                sqlDataAdapter.Fill(dataSet, currentTable);

                dataGridView1.DataSource = dataSet.Tables[currentTable];

                for (int i = 0; i < dataGridView1.Rows.Count; i++)
                {

                    DataGridViewLinkCell linkCell = new DataGridViewLinkCell();
                    dataGridView1[lastIndexTable, i] = linkCell;
                }

                dataGridView1.Refresh();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        /// <summary>
        /// Обработка событий связанных с добавлением новых данных
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void dataGridView1_UserAddedRow(object sender, DataGridViewRowEventArgs e)
        {
            try
            {
                if (!newRowAdding)
                {
                    newRowAdding = true;

                    int lastRow = dataGridView1.Rows.Count - 2;

                    DataGridViewRow row = dataGridView1.Rows[lastRow];

                    DataGridViewLinkCell linkCell = new DataGridViewLinkCell();

                    dataGridView1[lastIndexTable, lastRow] = linkCell;

                    row.Cells["Delete"].Value = "Insert";
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Error);
                throw;
            }
        }

        /// <summary>
        /// Обработка события связанный с нажатием на ячейку таблицы
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                if (e.ColumnIndex == lastIndexTable)
                {
                    string task = dataGridView1.Rows[e.RowIndex].Cells[lastIndexTable].Value.ToString();

                    if (task == "Delete")
                    {
                        if (MessageBox.Show("Удалить эту строку?", "Удаление", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
                            == DialogResult.Yes)
                        {
                            int rowIndex = e.RowIndex;

                            dataGridView1.Rows.RemoveAt(rowIndex);

                            dataSet.Tables[currentTable].Rows[rowIndex].Delete(); 

                            sqlDataAdapter.Update(dataSet, currentTable); // TABLE NAME
                        }

                    }
                    else if (task == "Insert")
                    {
                        int rowIndex = dataGridView1.Rows.Count - 2;
                        DataRow row = dataSet.Tables[currentTable].NewRow(); // TABLE NAME

                        for (int i = 0; i < dataGridView1.Columns.Count; i++)
                        {
                            string headerName = dataGridView1.Columns[i].HeaderText;
                            row[headerName] = dataGridView1.Rows[rowIndex].Cells[headerName].Value;
                        }

                        dataSet.Tables[currentTable].Rows.Add(row);

                        dataSet.Tables[currentTable].Rows.RemoveAt(dataSet.Tables[currentTable].Rows.Count - 1);

                        dataGridView1.Rows.RemoveAt(dataGridView1.Rows.Count - 2);

                        dataGridView1.Rows[e.RowIndex].Cells[lastIndexTable].Value = "Delete";

                        sqlDataAdapter.Update(dataSet, currentTable);

                        newRowAdding = false;
                    }
                    else if (task == "Update")
                    {

                        int r = e.RowIndex;

                        for (int i = 0; i < dataGridView1.Columns.Count; i++)
                        {
                            string headerName = dataGridView1.Columns[i].HeaderText;
                            dataSet.Tables[currentTable].Rows[r][headerName] = dataGridView1.Rows[r].Cells[headerName].Value;
                        }

                        sqlDataAdapter.Update(dataSet, currentTable);
                        dataGridView1.Rows[e.RowIndex].Cells[lastIndexTable].Value = "Delete";

                    }
                    ReloadData();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Error);
                throw;
            }
        }

        /// <summary>
        /// Обработка события
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void dataGridView1_EditingControlShowing(object sender, DataGridViewEditingControlShowingEventArgs e)
        {

        }

        /// <summary>
        /// Обработка события
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void dataGridView1_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                if (!newRowAdding)
                {
                    int rowIndex = dataGridView1.SelectedCells[0].RowIndex;

                    DataGridViewRow editingRow = dataGridView1.Rows[rowIndex];

                    DataGridViewLinkCell linkCell = new DataGridViewLinkCell();

                    dataGridView1[lastIndexTable, rowIndex] = linkCell;

                    editingRow.Cells["Delete"].Value = "Update";
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Error);
                throw;
            }
        }

        private void toolStripButton1_Click(object sender, EventArgs e)
        {
            try
            {
                ReloadData();
                dataGridView1.Refresh();
                dataGridView1.Update();
            }
            catch (Exception ex)
            {
                MessageBox.Show("", "ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Error);
                throw;
            }
        }

        private void richTextBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void toolStrip1_ItemClicked(object sender, ToolStripItemClickedEventArgs e)
        {

        }

        private void button4_Click(object sender, EventArgs e)
        {
            CreateOrderForm createOrderForm = new CreateOrderForm();
            createOrderForm.Show();
        }
    }
}
