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
    public partial class quiz : Form
    {
        public quiz()
        {
            InitializeComponent();
        }

        private void Button14_Click(object sender, EventArgs e)
        {
            Form mode = new Form1();
            mode.Owner = this;
            mode.Show();
            this.Hide();
        }

        private void Button2_Click(object sender, EventArgs e)
        {
            int suma = 0;
            if (this.radioButton3.Checked == true) suma++;
            if (this.radioButton5.Checked == true) suma++;
            if (this.radioButton9.Checked == true) suma++;
            if (this.radioButton12.Checked == true) suma++;
            if (this.radioButton14.Checked == true) suma++;
            if (this.radioButton16.Checked == true) suma++;
            if (this.radioButton20.Checked == true) suma++;
            if (this.radioButton24.Checked == true) suma++;
            if (this.radioButton26.Checked == true) suma++;
            if (this.radioButton30.Checked == true) suma++;
            if (suma <= 3) MessageBox.Show("Punctajul tău este: " + suma.ToString() + "/10 puncte." + " Mai ai de învățat multe despre make-up!");
            else if (suma >= 4 && suma <= 5) MessageBox.Show("Punctajul tău este: " + suma.ToString() + "/10 puncte." + " Te descurci de minune, deși mai ai de învățat câte ceva.");
            else if (suma >= 6) MessageBox.Show("Punctajul tău este: " + suma.ToString() + "/10 puncte." + " Bravo! Ai trecut cu brio testul!");


        }

        private void radioButton18_CheckedChanged(object sender, EventArgs e)
        {

        }
    }
}
