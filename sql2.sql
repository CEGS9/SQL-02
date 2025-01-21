-- criando tabelas

CREATE DATABASE LojaEstoque;
USE LojaEstoque;

CREATE TABLE Produtos (
    ProdutoID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Categoria VARCHAR(50),
    Preco DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Estoque (
    EstoqueID INT AUTO_INCREMENT PRIMARY KEY,
    ProdutoID INT NOT NULL,
    Quantidade INT DEFAULT 0,
    FOREIGN KEY (ProdutoID) REFERENCES Produtos(ProdutoID)
);

CREATE TABLE Movimentacoes (
    MovimentacaoID INT AUTO_INCREMENT PRIMARY KEY,
    ProdutoID INT NOT NULL,
    TipoMovimentacao ENUM('Entrada', 'Saida') NOT NULL,
    Quantidade INT NOT NULL,
    DataMovimentacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ProdutoID) REFERENCES Produtos(ProdutoID)
);

-- inserindo dados

INSERT INTO Produtos (Nome, Categoria, Preco)
VALUES
('Notebook', 'Eletrônicos', 3500.00),
('Mouse', 'Periféricos', 50.00),
('Teclado', 'Periféricos', 120.00);

INSERT INTO Estoque (ProdutoID, Quantidade)
VALUES
(1, 10), -- Notebook
(2, 50), -- Mouse
(3, 30); -- Teclado

--tigger

DELIMITER //

CREATE TRIGGER AtualizarEstoque
AFTER INSERT ON Movimentacoes
FOR EACH ROW
BEGIN
    IF NEW.TipoMovimentacao = 'Entrada' THEN
        UPDATE Estoque
        SET Quantidade = Quantidade + NEW.Quantidade
        WHERE ProdutoID = NEW.ProdutoID;
    ELSEIF NEW.TipoMovimentacao = 'Saida' THEN
        UPDATE Estoque
        SET Quantidade = Quantidade - NEW.Quantidade
        WHERE ProdutoID = NEW.ProdutoID;
    END IF;
END;
//

DELIMITER ;

INSERT INTO Movimentacoes (ProdutoID, TipoMovimentacao, Quantidade)
VALUES (2, 'Entrada', 20);

INSERT INTO Movimentacoes (ProdutoID, TipoMovimentacao, Quantidade)
VALUES (1, 'Saida', 5);

SELECT 
    EstoqueID, 
    ProdutoID, 
    Quantidade 
FROM Estoque;
