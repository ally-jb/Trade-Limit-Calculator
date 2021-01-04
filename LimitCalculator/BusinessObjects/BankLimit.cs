using System;

namespace BusinessObjects
{

    public class BankLimit
    {

        public string BankName { get; set; }
        public int Rating { get; set; }
        public long TotalAssets { get; set; }
        public long LimitAmt { get; set; }
        public DateTime LimitDate { get; set; }

    }

}