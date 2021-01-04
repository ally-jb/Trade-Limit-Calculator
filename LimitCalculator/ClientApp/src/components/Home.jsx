import React, {useState, useEffect } from 'react';
import service from '../services/service';
import { Table } from 'reactstrap';

const Home = () => {

const [limits, setLimits] = useState([]);

useEffect(() => {

  getBankLimits();

}, [])

const getBankLimits = async() => {

     const res = await service.get('BankLimit');
     const result = await res.json();
     
     setLimits(result);

}

  return (
    <div>
      <Table striped dark>
        <thead>
          <tr key="headerRow">{['Bank Name', 'Risk Rating', 'Total Assets', 'Trade Limit', 'Limit Date'].map(header => <th key={`header-${header}`}>{header}</th>)}</tr>
        </thead>
        <tbody>
          {limits.length > 0 ? limits.map((limit, index) => 
          <tr key={`body-row-${index}`}>
            <td key={`cell-BankName-${index}`}>{limit.bankName}</td>
            <td key={`cell-Rating-${index}`}>{`${limit.rating}`}</td>
            <td key={`cell-TotalAssets-${index}`}>{`$ ${new Intl.NumberFormat().format(limit.totalAssets)}`}</td>
            <td key={`cell-LimitAmt-${index}`}>{`$ ${new Intl.NumberFormat().format(limit.limitAmt)}`}</td>
            <td key={`cell-LimitDate-${index}`}>{new Date(limit.limitDate).toLocaleDateString()}</td>
          </tr>) 
          : <tr><td colSpan={5}>No data to display</td></tr>}
        </tbody>
      </Table>
    </div>
  );

}

export default Home
