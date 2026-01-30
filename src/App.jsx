import './App.css'
import { Route, Routes } from "react-router-dom"
import Test from './Test'

function App() {

  return (
    <Routes>
      <Route path="/" element={<Test/>}/>
    </Routes>
  )
}

export default App
