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
    public partial class favorite : Form
    {
        public favorite()
        {
            InitializeComponent();
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
            MessageBox.Show("ATODERM este o gama de produse dermatologice de ingrijire, special formulata pentru pielea uscata, foarte uscata si atopica, ce poate fi folosita atat pe fata, cat si pe corp. Sunt inspirate de piele, de propriile ei mecanisme de aparare, reparare, regenerare si adaptare.", "Gama Atoderm by Bioderma", MessageBoxButtons.OK , MessageBoxIcon.Asterisk);
        }

        private void Button3_Click(object sender, EventArgs e)
        {
            MessageBox.Show("Ati vazut-o in cel mai recent tutorial, cel cu machiajul in nuante neutre. E o paleta de farduri neutre, mate – doar una are un finish usor perlat. Nuantele sunt pigmentate, iar textura e una catifelata, astfel ca nu aveti parte de surplus de fard pe pometi atunci cand o folositi. E o paleta perfecta pentru everyday use si machiaje de zi.", "Urban Decay Ultimate Basics Palette", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);


        }

        private void Button4_Click(object sender, EventArgs e)
        {
            MessageBox.Show("Acest blush este cea mai noua lansare de la Benefit. E un roz piersica auriu, discret, perfect pentru machiajele de zi sau machiajele in care puneti accent pe ochi si buze si vreti ca restul fetei sa fie mai „cuminte”. Miroase foarte bine si dulce, iar ambalajul e adorabil, inspirat de anii ’70.", "Benefit GALifornia Blush", MessageBoxButtons.OK , MessageBoxIcon.Asterisk);
        }

        private void Button5_Click(object sender, EventArgs e)
        {
            MessageBox.Show("Am primit acest set superb cu 21 de nuante de la Sephora, printre care si cele 16 nuante noi lansate. Sunt foarte pigmentate si usor de aplicat, nu aveti nevoie de creion de buze in prealabil. Sunt rezistente, iar nuantele sunt diverse si superbe. O sa revin in curand cu clip cu swatch-uri si review.", "Sephora Cream Lip Stain", MessageBoxButtons.OK , MessageBoxIcon.Asterisk);
        }
    }
}
