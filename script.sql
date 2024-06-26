USE [ForexRates]
GO
/****** Object:  Table [dbo].[ForexRates]    Script Date: 5/24/2024 6:20:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ForexRates](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[base_currency] [nvarchar](50) NOT NULL,
	[target_currency] [decimal](18, 0) NOT NULL,
	[exchange_rate] [float] NOT NULL,
	[updated_time] [datetime] NOT NULL,
 CONSTRAINT [PK__ForexRat__3213E83FCA7E399D] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[insertDulieu]    Script Date: 5/24/2024 6:20:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insertDulieu]
    @base_currency NVARCHAR(50),
    @target_currency decimal(18,0),
    @exchange_rate FLOAT,
    @updated_time DATETIME
AS
BEGIN
    INSERT INTO ForexRates(base_currency, target_currency, exchange_rate, updated_time)
    VALUES (@base_currency, @target_currency, @exchange_rate, @updated_time);
END;
GO
/****** Object:  StoredProcedure [dbo].[InsertDulieuJson]    Script Date: 5/24/2024 6:20:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertDulieuJson]
   
    @json NVARCHAR(MAX)= null
AS
BEGIN
    DECLARE @base_currency NVARCHAR(50);
    DECLARE @target_currency DECIMAL(18, 0);
    DECLARE @exchange_rate FLOAT;
    DECLARE @updated_time DATETIME;

    -- Phân tích JSON và gán giá trị cho các biến
    SELECT 
        @base_currency = JSON_VALUE(@json, '$.base'),
        @target_currency = CAST(JSON_VALUE(@json, '$.result.VND') AS DECIMAL(18, 0)),
        @exchange_rate = CAST(JSON_VALUE(@json, '$.result.VND') AS FLOAT),
        @updated_time = CONVERT(DATETIME, JSON_VALUE(@json, '$.updated'));

    -- Chèn dữ liệu vào bảng ExchangeRates
    INSERT INTO ForexRates(base_currency, target_currency, exchange_rate, updated_time)
    VALUES (@base_currency, @target_currency, @exchange_rate, @updated_time);
END;
GO
/****** Object:  StoredProcedure [dbo].[InsertForexRate]    Script Date: 5/24/2024 6:20:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertForexRate]
    @base_currency NVARCHAR(3),
    @target_currency NVARCHAR(3),
    @exchange_rate FLOAT,
    @updated_time DATETIME
AS
BEGIN
    -- Kiểm tra xem các tham số đầu vào có hợp lệ không
    IF @base_currency IS NOT NULL AND @target_currency IS NOT NULL AND @exchange_rate IS NOT NULL AND @updated_time IS NOT NULL
    BEGIN
        -- Chèn dữ liệu vào bảng ForexRates
        INSERT INTO ForexRates (base_currency, target_currency, exchange_rate, updated_time)
        VALUES (@base_currency, @target_currency, @exchange_rate, @updated_time);
        
        -- Trả về thông báo thành công
        SELECT 'Dữ liệu đã được chèn thành công vào bảng ForexRates.';
    END
    ELSE
    BEGIN
        -- Trả về thông báo lỗi nếu các tham số đầu vào không hợp lệ
        THROW 50001, 'Các tham số đầu vào không hợp lệ.', 1;
    END
END;
GO
