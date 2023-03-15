using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace WindowsFormsApp1
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Label1_Click(object sender, EventArgs e)
        {

        }

        private void Button1_Click(object sender, EventArgs e)
        {
            Form mode = new PaginaPornire();
            mode.Owner = this;
            mode.Show();
            this.Hide();
        }

        private void Button2_Click(object sender, EventArgs e)
        {
            Form mode = new quiz();
            mode.Owner = this;
            mode.Show();
            this.Hide();
        }

        private void Button3_Click(object sender, EventArgs e)
        {
            //this.Owner.Show();
            this.Close();
            //Form1.ActiveForm.Close();
            Application.Exit();
        }
    }
}
