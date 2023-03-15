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
    public partial class PaginaPornire : Form
    {
        public PaginaPornire()
        {
            InitializeComponent();
        }

        private void Button3_Click(object sender, EventArgs e)
        {
            Form mode = new informatii();
            mode.Owner = this;
            mode.Show();
            this.Hide();
        }

        private void Button14_Click(object sender, EventArgs e)
        {
            Form mode = new Form1();
            mode.Owner = this;
            mode.Show();
            this.Hide();

        }

        private void Button1_Click(object sender, EventArgs e)
        {
            Form mode = new transport();
            mode.Owner = this;
            mode.Show();
            this.Hide();
        }

        private void Button2_Click(object sender, EventArgs e)
        {

            Form mode = new favorite();
            mode.Owner = this;
            mode.Show();
            this.Hide();
        }

        private void Button7_Click(object sender, EventArgs e)
        {
            Form mode = new Ochi();
            mode.Owner = this;
            mode.Show();
            this.Hide();
        }

        private void Button13_Click(object sender, EventArgs e)
        {
            Form mode = new Sprancene();
            mode.Owner = this;
            mode.Show();
            this.Hide();
        }

        private void Button4_Click(object sender, EventArgs e)
        {
            Form mode = new Ruj();
            mode.Owner = this;
            mode.Show();
            this.Hide();
        }

        private void Button5_Click(object sender, EventArgs e)
        {
            Form mode = new Lipstick();
            mode.Owner = this;
            mode.Show();
            this.Hide();
        }

        private void Button9_Click(object sender, EventArgs e)
        {
            Form mode = new Pensula();
            mode.Owner = this;
            mode.Show();
            this.Hide();
        }

        private void Button6_Click(object sender, EventArgs e)
        {
            Form mode = new Crema();
            mode.Owner = this;
            mode.Show();
            this.Hide();
        }

        private void Button12_Click(object sender, EventArgs e)
        {
            Form mode = new Masca();
            mode.Owner = this;
            mode.Show();
            this.Hide();
        }

        private void Button8_Click(object sender, EventArgs e)
        {
            Form mode = new oja();
            mode.Owner = this;
            mode.Show();
            this.Hide();
        }

        private void Button11_Click(object sender, EventArgs e)
        {
            Form mode = new Ser();
            mode.Owner = this;
            mode.Show();
            this.Hide();
        }

        private void Button10_Click(object sender, EventArgs e)
        {
            Form mode = new accesorii();
            mode.Owner = this;
            mode.Show();
            this.Hide();
        }
    }
}
