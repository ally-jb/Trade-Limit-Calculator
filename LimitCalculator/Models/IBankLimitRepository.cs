using BusinessObjects;
using System.Collections.Generic;

namespace Models {

    public interface IBankLimitRepository {
        IEnumerable<BankLimit> GetLimits();
    }

}